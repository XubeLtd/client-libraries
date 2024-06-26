// import 'dart:convert';
// import 'dart:developer';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:xube_client/src/utils/subscription_manager.dart';
// import 'package:xube_client/xube_client.dart';

// class XubeClientProject {
//   final WebSocketChannel _channel;
//   final XubeClientAuth _auth;
//   final SubscriptionManager _subscriptionManager;

//   XubeClientProject({
//     required WebSocketChannel channel,
//     required XubeClientAuth auth,
//     SubscriptionManager? subscriptionManager,
//   })  : _channel = channel,
//         _auth = auth,
//         _subscriptionManager =
//             subscriptionManager ?? SubscriptionManager.instance;

//   void unsubscribe(String accountId, String projectId) {
//     _channel.sink.add(
//       json.encode({
//         "action": "Unsubscribe",
//         "format": "View",
//         "contextKey": "PROJECT",
//         "contextId": projectId,
//         "typeKey": "ACCOUNT",
//         "typeId": accountId,
//       }),
//     );

//     _subscriptionManager.unsubscribe(
//       format: "View",
//       contextKey: "PROJECT",
//       contextId: projectId,
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );
//   }

//   Stream? getProjectStream(String accountId, String projectId) {
//     if (!_auth.isAuthenticated || _auth.userId == null || _auth.email == null) {
//       return null;
//     }

//     var stream = _subscriptionManager.findStreamById(
//       format: "View",
//       contextKey: "PROJECT",
//       contextId: projectId,
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     if (stream != null) return stream;

//     log('getProjectStream: subscribing to $projectId');
//     _channel.sink.add(
//       json.encode({
//         "action": "Subscribe",
//         "format": "View",
//         "contextKey": "PROJECT",
//         "contextId": projectId,
//         "typeKey": "ACCOUNT",
//         "typeId": accountId,
//       }),
//     );

//     _subscriptionManager.saveSubscriptionId(
//       format: "View",
//       contextKey: "PROJECT",
//       contextId: projectId,
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     stream = _subscriptionManager.findStreamById(
//       format: "View",
//       contextKey: "PROJECT",
//       contextId: projectId,
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     log('getProjectStream: $stream');
//     return stream;
//   }
// }
