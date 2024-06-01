// import 'dart:convert';
// import 'dart:developer';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:xube_client/src/utils/subscription_manager.dart';
// import 'package:xube_client/xube_client.dart';

// class XubeClientCodes {
//   final WebSocketChannel _channel;
//   final XubeClientAuth _auth;
//   final SubscriptionManager _subscriptionManager;

//   XubeClientCodes({
//     required WebSocketChannel channel,
//     required XubeClientAuth auth,
//     SubscriptionManager? subscriptionManager,
//   })  : _channel = channel,
//         _auth = auth,
//         _subscriptionManager =
//             subscriptionManager ?? SubscriptionManager.instance;

//   void unsubscribe(String accountId) {
//     _channel.sink.add(
//       json.encode(
//         {
//           "action": "Unsubscribe",
//           "format": "View",
//           "contextKey": "COMPONENT#CODE",
//           "typeKey": "ACCOUNT",
//           "typeId": accountId,
//         },
//       ),
//     );

//     _subscriptionManager.unsubscribe(
//       format: "View",
//       contextKey: "COMPONENT#CODE",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );
//   }

//   Future<void> createCode({
//     required String accountId,
//     required String codeType,
//     required String file,
//     required String name,
//   }) async {
//     const url = '/code';

//     try {
//       final data = {
//         'account': accountId,
//         'codeType': 'Driver',
//         'file': file,
//         'name': name,
//       };

//       await submit(
//         data: data,
//         path: url,
//         authToken: _auth.token,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Stream? getCodesStream(String accountId) {
//     if (!_auth.isAuthenticated || _auth.userId == null || _auth.email == null) {
//       return null;
//     }

//     var stream = _subscriptionManager.findStreamById(
//       format: "View",
//       contextKey: "COMPONENT#CODE",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     if (stream != null) return stream;

//     _channel.sink.add(
//       json.encode(
//         {
//           "action": "Subscribe",
//           "format": "View",
//           "contextKey": "COMPONENT#CODE",
//           "typeKey": "ACCOUNT",
//           "typeId": accountId,
//         },
//       ),
//     );

//     _subscriptionManager.saveSubscriptionId(
//       format: "View",
//       contextKey: "COMPONENT#CODE",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     stream = _subscriptionManager.findStreamById(
//       format: "View",
//       contextKey: "COMPONENT#CODE",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     log('getCodesStream: $stream');
//     return stream;
//   }
// }
