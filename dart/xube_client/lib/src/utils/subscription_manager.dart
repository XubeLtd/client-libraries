import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/subjects.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/models/subscription_data/subscription_data.dart';
import 'package:xube_client/src/utils/xube_log.dart';
import 'package:xube_client/src/xube_client.dart';

class XubeSubscription<T, U> {
  final String id;
  final XubeLog _log;
  final _controller = BehaviorSubject<T>();
  final T Function(U data) convertData;

  XubeSubscription({
    required this.id,
    required this.convertData,
  }) : _log = XubeLog.getInstance();

  Stream get stream => _controller.stream;

  void addData(dynamic data) {
    _log.info('Adding data: $data to XubeSubscription $id');

    if (data is List) {
      data = List<Map<String, dynamic>>.from(data);
    } else if (data is Map) {
      data = Map<String, dynamic>.from(data);
    } else {
      _log.error('Data is not a list or map. Ignoring');
      return;
    }

    T convertedData = convertData(data);
    _controller.add(convertedData);
  }

  void close() {
    _log.info('Closing XubeSubscription $id');
    _controller.close();
  }
}

enum SubscriptionState { uninitialized, ready, pending, closed }

class SubscriptionManager {
  final String _baseSocketPath;
  final XubeLog _log;
  WebSocket? _socket;
  User? _user;
  String? _connectionId;

  late final Map<String, XubeSubscription> _subscriptions;

  BehaviorSubject subscriptionStateSubject =
      BehaviorSubject<SubscriptionState>.seeded(
    SubscriptionState.uninitialized,
  );

  StreamSubscription? socketSubscription;

  SubscriptionManager(
    String baseApiPath,
    String baseSocketPath,
    XubeLog? log,
  )   : _baseSocketPath = baseSocketPath,
        _log = log ?? XubeLog.getInstance(),
        _subscriptions = {} {
    _setConnectionIdForSubscribeRequests();
    _listenToAuthStream();
  }

  _listenToAuthStream() {
    GetIt.I<XubeClientAuth>().authStream.listen((user) {
      _user = user;

      if (_socket != null) {
        _log.info('Socket is already being managed. Ignoring');
        return;
      }

      _initSocket();
    });
  }

  _initSocket() async {
    String? authToken = _user?.token;

    if (authToken == null) {
      _log.warning('No token found');
      teardown();
      return;
    }

    try {
      Random r = Random();
      String key = base64.encode(List<int>.generate(8, (_) => r.nextInt(255)));

      _socket = await WebSocket.connect(
        '$_baseSocketPath?token=$authToken',
        headers: {
          'Connection': 'Upgrade',
          'Upgrade': 'websocket',
          'Sec-WebSocket-Version': '13',
          'Sec-WebSocket-Key': key,
          'Sec-WebSocket-Extensions':
              'permessage-deflate; client_max_window_bits',
          'Authorization': authToken,
        },
      );

      socketSubscription = _socket?.listen(
        handleSocketEvent,
        onDone: handleSocketDone,
        onError: (error) {
          _log.error('Socket error: $error');
          teardown();
        },
      );

      triggerSocketConnectionIdResponse();

      subscriptionStateSubject.sink.add(SubscriptionState.pending);
    } catch (e) {
      _log.error('Could not connect to socket', error: e);
      teardown();
      return;
    }
  }

  void triggerSocketConnectionIdResponse() {
    _socket?.add(
      'Hello!',
    ); //Random 'forbidden' message to get the connection id from backend
  }

  void _setConnectionIdForSubscribeRequests() {
    GetIt.I<Dio>().interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_connectionId != null && options.path.endsWith('subscribe')) {
          options.data ??= {};
          options.data['destination'] = _connectionId;
        }

        return handler.next(options);
      },
    ));
  }

  void handleSocketDone() {
    _log.info('Socket closed. Attempting to reconnect.');
    subscriptionStateSubject.add(SubscriptionState.uninitialized);
    _initSocket();
  }

  void handleSocketEvent(event) async {
    _log.info('Received event: $event');
    dynamic decodedDelivery = jsonDecode(event);

    if (decodedDelivery['connectionId'] != null &&
        subscriptionStateSubject.value != SubscriptionState.ready) {
      String newConnectionId = decodedDelivery['connectionId'];
      setConnectionId(newConnectionId);
      subscriptionStateSubject.sink.add(SubscriptionState.ready);
    }

    if (decodedDelivery['data'] == null) {
      _log.info('Event does not contain data. Ignoring');
      return;
    }

    SubscriptionDelivery? subscriptionDelivery =
        SubscriptionDelivery.fromJson(decodedDelivery, log: _log);

    if (subscriptionDelivery == null) {
      _log.critical(
          'SubscriptionManager - Could not generate Subscription delivery from $event');
      return;
    }

    for (String subscriptionPath in subscriptionDelivery.subscriptionPaths) {
      feed(path: subscriptionPath, data: subscriptionDelivery.data);
    }
  }

  void setConnectionId(
    String newConnectionId,
  ) async {
    String? oldConnectionId = _connectionId;
    _connectionId = newConnectionId;

    if (oldConnectionId == null) {
      _log.info(
        'No old connection id found when setting connection id. This is likely the first time the connection id is being set. Skipping refresh.',
      );
      return;
    }

    try {
      Response response = await GetIt.I<Dio>().post(
        '/subscriptions/refresh',
        data: {
          "oldConnectionId": oldConnectionId,
          "newConnectionId": newConnectionId
        },
      );

      int? statusCode = response.statusCode;

      if (statusCode == null) {
        _log.error(
          'No status code received when refreshing connection id',
          error: response,
        );
      } else if (statusCode >= HttpStatus.internalServerError) {
        _log.error(
          'Could not refresh connection id',
          error: response,
        );
      }
    } catch (e) {
      _log.error('Could not refresh connection id', error: e);
    }
  }

  void teardown() async {
    _log.info('Tearing down subscription manager');

    subscriptionStateSubject.add(SubscriptionState.closed);

    _subscriptions.forEach((id, xubeSubscription) {
      xubeSubscription.close();
    });
    _subscriptions.clear();

    await _socket?.close();
    _socket = null;
  }

  String _formatId({
    required String path,
  }) {
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    return path.toLowerCase();
  }

  Stream<T>? findStreamById<T>({required String path}) {
    final id = _formatId(
      path: path.toLowerCase(),
    );

    Stream? stream = _subscriptions[id]?.stream;

    if (stream != null && stream is Stream<T>) {
      return stream;
    }

    _log.warning('No valid stream found for $id');

    return null;
  }

  void feed({
    required String path,
    dynamic data,
  }) {
    final id = _formatId(path: path);
    XubeSubscription? subscription = _subscriptions[id];

    if (subscription == null) {
      _log.info('No subscription found for $id');
      return;
    }

    _subscriptions[id]?.addData(data);
  }

  XubeSubscription<T, U> saveSubscription<T, U>({
    required String path,
    required T Function(U data) convertData,
  }) {
    final id = _formatId(path: path);

    _log.info('Adding new XubeSubscription $id to the Subscription Manager');

    final newSubscription = XubeSubscription<T, U>(
      id: id,
      convertData: convertData,
    );

    _subscriptions.putIfAbsent(id, () => newSubscription);

    return newSubscription;
  }

  Stream<T> subscribe<T, U>({
    required String path,
    required T Function(U data) convertData,
  }) {
    _log.info('Subscription Manager - subscribing to path: $path');

    XubeSubscription<T, U> subscription = saveSubscription<T, U>(
      path: path,
      convertData: convertData,
    );

    try {
      StreamSubscription? subscribeStateStreamSubscription;

      subscribeStateStreamSubscription = subscriptionStateSubject.listen(
        (event) {
          if (event == SubscriptionState.ready) {
            _handleManagerStateReadyToSubscribe<T, U>(
              path,
              subscription,
              convertData,
            );
            subscribeStateStreamSubscription?.cancel();
          }
        },
      );
    } catch (e) {
      _log.error('Could not subscribe to path: $path. Error: $e');
    }

    return subscription._controller.stream;
  }

  _handleManagerStateReadyToSubscribe<T, U>(
    String path,
    XubeSubscription subscription,
    T Function(U data) convertData,
  ) async {
    final id = _formatId(path: path);

    _log.info('Subscription Manager - socket is ready. Subscribing to $id');
    if (_connectionId == null) {
      _log.error('No connection id found');
    }
    Dio _dio = GetIt.I<Dio>();

    // Dio dio = new Dio();

    // dio.interceptors.add(_dio.interceptors.first);
    // dio.interceptors.add(_dio.interceptors.last);

    try {
      // if(path.startsWith('/')){
      //   path = path.substring(1);
      // }

      // String fullPath = "${_dio.options.baseUrl}$path";
      _log.info("Making request to: $path");
      Response response = await _dio.post(path);

      if ((response.statusCode ?? HttpStatus.internalServerError) >=
          HttpStatus.multipleChoices) {
        _log.error(
          'Could not subscribe to $id on server side',
          error: response,
        );
        return null;
      }

      subscription.addData(response.data);
    } catch (e) {
      _log.info(jsonEncode(_dio));
      _log.error('Could not subscribe to $id', error: e);
    }
  }

  Future<void> unsubscribe({
    required String path,
  }) async {
    final id = _formatId(path: path);

    Dio _dio = GetIt.I<Dio>();

    try {
      Response response = await _dio.delete(path);

      int? statusCode = response.statusCode;

      _subscriptions[id]?.close();
      _subscriptions.remove(id);

      if (statusCode == null) {
        _log.error(
          'No status code received when unsubscribing from $path',
          error: response,
        );
        _log.warning('Unsubscription may have only been partially successful');
        return;
      }

      if (statusCode >= HttpStatus.multipleChoices) {
        _log.warning('Server could not complete unsubscription from $id',
            error: response);
        return;
      }
      _log.info('Subscription Manager - unsubscribed from $id');
    } catch (e) {
      _log.error('Could not unsubscribe from $id', error: e);
    }
  }
}
