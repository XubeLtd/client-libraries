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

class XubeSubscription<T> {
  final String id;
  final XubeLog _log;
  final _controller = BehaviorSubject<T>();
  final T Function(Map<String, dynamic> data) convertData;

  XubeSubscription({
    required this.id,
    required this.convertData,
  }) : _log = XubeLog.getInstance();

  Stream get stream => _controller.stream;

  void addData(dynamic data) {
    _log.info('Adding data: $data to XubeSubscription $id');

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

    if (decodedDelivery['connectionId'] != null) {
      _connectionId = decodedDelivery['connectionId'];
      subscriptionStateSubject.sink.add(SubscriptionState.ready);
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
    return path;
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

    _subscriptions[id]?.addData(data);
  }

  XubeSubscription<T> saveSubscription<T>({
    required String path,
    required T Function(Map<String, dynamic> data) convertData,
  }) {
    final id = _formatId(path: path);

    _log.info('Adding new XubeSubscription $id to the Subscription Manager');

    final newSubscription = XubeSubscription<T>(
      id: id,
      convertData: convertData,
    );

    _subscriptions.putIfAbsent(id, () => newSubscription);

    return newSubscription;
  }

  Stream<T> subscribe<T>({
    required String path,
    required T Function(Map<String, dynamic> data) convertData,
  }) {
    _log.info('Subscription Manager - subscribing to path: $path');

    XubeSubscription<T> subscription = saveSubscription<T>(
      path: path,
      convertData: convertData,
    );

    try {
      StreamSubscription? subscribeStateStreamSubscription;

      subscribeStateStreamSubscription = subscriptionStateSubject.listen(
        (event) {
          if (event == SubscriptionState.ready) {
            _handleManagerStateReadyToSubscribe<T>(
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

  _handleManagerStateReadyToSubscribe<T>(
    String path,
    XubeSubscription subscription,
    T Function(Map<String, dynamic> data) convertData,
  ) async {
    final id = _formatId(path: path);

    _log.info('Subscription Manager - socket is ready. Subscribing to $id');
    if (_connectionId == null) {
      _log.error('No connection id found');
    }
    Dio _dio = GetIt.I<Dio>();

    try {
      Response response = await _dio.post(
        path,
      );

      if ((response.statusCode ?? HttpStatus.internalServerError) >=
          HttpStatus.multipleChoices) {
        _log.error(
          'Could not subscribe to $id on server side',
          error: response,
        );
        return null;
      }

      dynamic object = jsonDecode(response.data);
      T data = convertData(object);
      subscription._controller.add(data);
    } catch (e) {
      _log.error('Could not subscribe to $id', error: e);
    }
  }

  Future<void> unsubscribe({
    required String path,
  }) async {
    final id = _formatId(path: path);

    Dio _dio = GetIt.I<Dio>();
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
  }
}
