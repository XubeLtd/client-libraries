import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:xube_client/src/utils/subcscription_manager.dart';
import 'package:xube_client/xube_client.dart';
import 'dart:convert';

class XubeClientAccount {
  final WebSocketChannel _channel;
  final XubeClientAuth _auth;
  final SubscriptionManager _subscriptionManager;

  XubeClientAccount({
    required WebSocketChannel channel,
    required XubeClientAuth auth,
    SubscriptionManager? subscriptionManager,
  })  : _channel = channel,
        _auth = auth,
        _subscriptionManager =
            subscriptionManager ?? SubscriptionManager.instance;

  Stream? getAccountStream(String accountId) {
    return Stream.fromFuture(
            rootBundle.loadString('assets/examples/account/account.json'))
        .asBroadcastStream();

    // if (!_auth.isAuth || _auth.userId == null || _auth.email == null) {
    //   return null;
    // }

    // var stream = _subscriptionManager.findStreamById(accountId);
    // if (stream != null) return stream;

    // log('getUserAccountsStream: subscribing to play@xube.io');
    // _channel.sink.add(
    //   json.encode({
    //     "action": "Subscribe",
    //     "format": "View",
    //     "contextType": "ACCOUNT",
    //     "subscriptionType": "ACCOUNT",
    //     "subscriptionID": accountId,
    //   }),
    // );

    // _subscriptionManager.createSubscription(accountId);
    // stream = _subscriptionManager.findStreamById(accountId);

    // log('getAccountStream: $stream');
    // return stream;
  }
}
