// import 'dart:convert';
// import 'dart:developer';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:xube_client/src/utils/subscription_manager.dart';
// import 'package:xube_client/xube_client.dart';

// class XubeClientGroup {
//   final WebSocketChannel _channel;
//   final XubeClientAuth _auth;
//   final SubscriptionManager _subscriptionManager;

//   XubeClientGroup({
//     required WebSocketChannel channel,
//     required XubeClientAuth auth,
//     SubscriptionManager? subscriptionManager,
//   })  : _channel = channel,
//         _auth = auth,
//         _subscriptionManager =
//             subscriptionManager ?? SubscriptionManager.instance;

//   void unsubscribe(String accountId, String groupId) {
//     _channel.sink.add(
//       json.encode({
//         "action": "Unsubscribe",
//         "format": "Raw",
//         "contextKey": "COMPONENT#$groupId",
//         "typeKey": "ACCOUNT",
//         "typeId": accountId,
//       }),
//     );

//     _subscriptionManager.unsubscribe(
//       format: "Raw",
//       contextKey: "COMPONENT#$groupId",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );
//   }

//   Group? _groupTransformer(dynamic event) {
//     final items = (event['items'] as List);
//     List<Group> groups = [];

//     if (items.isNotEmpty) {
//       groups = items.map((e) => Group.fromJson(e)).toList();
//       return groups.first;
//     }
//     return null;
//   }

//   Stream<Group?>? getGroupStream(String accountId, String groupId) {
//     if (!_auth.isAuthenticated || _auth.userId == null || _auth.email == null) {
//       return null;
//     }

//     var stream = _subscriptionManager
//         .findStreamById(
//           format: "Raw",
//           contextKey: "COMPONENT#$groupId",
//           typeKey: "ACCOUNT",
//           typeId: accountId,
//         )
//         ?.map(_groupTransformer);

//     if (stream != null) return stream;

//     log('getGroupStream: subscribing to $groupId');

//     _channel.sink.add(
//       json.encode({
//         "action": "Subscribe",
//         "format": "Raw",
//         "contextKey": "COMPONENT#$groupId",
//         "typeKey": "ACCOUNT",
//         "typeId": accountId,
//       }),
//     );

//     _subscriptionManager.saveSubscriptionId(
//       format: "Raw",
//       contextKey: "COMPONENT#$groupId",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     stream = _subscriptionManager
//         .findStreamById(
//           format: "Raw",
//           contextKey: "COMPONENT#$groupId",
//           typeKey: "ACCOUNT",
//           typeId: accountId,
//         )
//         ?.map(_groupTransformer);

//     log('getGroupStream: $stream');
//     return stream;
//   }

//   Future<void> linkComponentsToGroup({
//     required String accountId,
//     required List<String> components,
//     required String groupId,
//   }) async {
// //     {
// // 	"account": "Gabor",
// // 	"children": ["DEVICE_2128761e-0076-4752-9377-69e6bb0301aa", "DEVICE_784baf6e-b401-4158-938e-e4ab8c651d6d"],
// // 	"parent": "GROUP_0d426658-a7b4-4e1b-a54c-213b5e544cbe"
// // }
//     const url = '/groups';

//     try {
//       final data = {
//         'account': accountId,
//         'children': components,
//         'parent': groupId,
//       };

//       await submit(
//         method: 'patch',
//         data: data,
//         path: url,
//         authToken: _auth.token,
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
