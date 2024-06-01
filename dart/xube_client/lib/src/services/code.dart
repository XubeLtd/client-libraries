// import 'dart:convert';
// import 'dart:developer';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:xube_client/src/utils/subscription_manager.dart';
// import 'package:xube_client/xube_client.dart';

// class XubeClientCode {
//   final WebSocketChannel _channel;
//   final XubeClientAuth _auth;
//   final SubscriptionManager _subscriptionManager;

//   XubeClientCode({
//     required WebSocketChannel channel,
//     required XubeClientAuth auth,
//     SubscriptionManager? subscriptionManager,
//   })  : _channel = channel,
//         _auth = auth,
//         _subscriptionManager =
//             subscriptionManager ?? SubscriptionManager.instance;

//   void unsubscribe(String accountId, String codeId) {
//     _channel.sink.add(
//       json.encode(
//         {
//           "action": "Unsubscribe",
//           "format": "View",
//           "contextKey": "COMPONENT#CODE$codeId",
//           "typeKey": "ACCOUNT",
//           "typeId": accountId,
//         },
//       ),
//     );

//     _subscriptionManager.unsubscribe(
//       format: "View",
//       contextKey: "COMPONENT#CODE$codeId",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );
//   }

//   Stream? getCodeStream(String accountId, String codeId) {
//     if (!_auth.isAuthenticated || _auth.userId == null || _auth.email == null) {
//       return null;
//     }

//     var stream = _subscriptionManager.findStreamById(
//       format: "View",
//       contextKey: "COMPONENT#CODE$codeId",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     if (stream != null) return stream;

//     _channel.sink.add(
//       json.encode(
//         {
//           "action": "Subscribe",
//           "format": "View",
//           "contextKey": "COMPONENT#CODE$codeId",
//           "typeKey": "ACCOUNT",
//           "typeId": accountId,
//         },
//       ),
//     );

//     _subscriptionManager.saveSubscriptionId(
//       format: "View",
//       contextKey: "COMPONENT#CODE$codeId",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     stream = _subscriptionManager.findStreamById(
//       format: "View",
//       contextKey: "COMPONENT#CODE$codeId",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     log('getCodeStream: $stream');
//     return stream;
//   }
// }
