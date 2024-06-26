// import 'dart:developer';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:xube_client/src/utils/subscription_manager.dart';
// import 'package:xube_client/xube_client.dart';
// import 'dart:convert';

// class XubeClientDataEndpoint {
//   final WebSocketChannel _channel;
//   final XubeClientAuth _auth;
//   final SubscriptionManager _subscriptionManager;

//   XubeClientDataEndpoint({
//     required WebSocketChannel channel,
//     required XubeClientAuth auth,
//     SubscriptionManager? subscriptionManager,
//   })  : _channel = channel,
//         _auth = auth,
//         _subscriptionManager =
//             subscriptionManager ?? SubscriptionManager.instance;

//   void unsubscribe(String accountId) {
//     _channel.sink.add(
//       json.encode({
//         "action": "Unsubscribe",
//         "format": "View",
//         "contextKey": "DATA-ENDPOINT",
//         "contextId": "CURRENT",
//         "typeKey": "ACCOUNT",
//         "typeId": accountId,
//       }),
//     );

//     _subscriptionManager.unsubscribe(
//       format: "View",
//       contextKey: "DATA-ENDPOINT",
//       contextId: "CURRENT",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );
//   }

//   Stream? getDataEndpointStream(String accountId) {
//     if (!_auth.isAuthenticated || _auth.userId == null || _auth.email == null) {
//       return null;
//     }

//     var stream = _subscriptionManager.findStreamById(
//       format: "View",
//       contextKey: "DATA-ENDPOINT",
//       contextId: "CURRENT",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     if (stream != null) return stream;

//     _channel.sink.add(
//       json.encode({
//         "action": "Subscribe",
//         "format": "View",
//         "contextKey": "DATA-ENDPOINT",
//         "contextId": "CURRENT",
//         "typeKey": "ACCOUNT",
//         "typeId": accountId,
//       }),
//     );

//     _subscriptionManager.saveSubscriptionId(
//       format: "View",
//       contextKey: "DATA-ENDPOINT",
//       contextId: "CURRENT",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     stream = _subscriptionManager.findStreamById(
//       format: "View",
//       contextKey: "DATA-ENDPOINT",
//       contextId: "CURRENT",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     log('getDataEndpointStream: $stream');
//     return stream;
//   }

//   Future<void> setEndpoint(
//     String accountId,
//     String endpoint,
//   ) async {
//     const url = '/data/endpoint';
//     try {
//       final responseData = await submit(
//         data: {
//           'account': accountId,
//           'endpoint': endpoint,
//         },
//         path: url,
//         authToken: _auth.token!,
//         method: 'patch',
//       );

//       log('setEndpoint responseData: $responseData');
//     } catch (error) {
//       rethrow;
//     }
//   }
// }
