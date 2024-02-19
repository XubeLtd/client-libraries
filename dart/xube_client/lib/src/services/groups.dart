// import 'dart:convert';
// import 'dart:developer';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:xube_client/src/utils/subscription_manager.dart';
// import 'package:xube_client/xube_client.dart';

// class XubeClientGroups {
//   final WebSocketChannel _channel;
//   final XubeClientAuth _auth;
//   final SubscriptionManager _subscriptionManager;

//   XubeClientGroups({
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
//           "format": "Raw",
//           "contextKey": "COMPONENT#GROUP",
//           "typeKey": "ACCOUNT",
//           "typeId": accountId,
//         },
//       ),
//     );

//     _subscriptionManager.unsubscribe(
//       format: "Raw",
//       contextKey: "COMPONENT#GROUP",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );
//   }

//   Future<void> createGroup({
//     required String accountId,
//     required String groupName,
//   }) async {
//     const url = '/groups';

//     try {
//       final data = {
//         'account': accountId,
//         'groupName': groupName,
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

//   List<Group> _groupsTransformer(dynamic event) {
//     List<Group> groups = [];

//     final items = (event['items'] as List);
//     print('debug _groupsTransformer items ${items.length}');

//     try {
//       if (items.isNotEmpty) {
//         groups = items.map((e) => Group.fromJson(e)).toList();
//       }
//     } catch (e) {
//       print('debug _groupsTransformer error $e ');
//     }

//     print('debug _groupsTransformer groups ${groups.length}');

//     return groups;
//   }

//   Stream<List<Group>>? getGroupsStream(String accountId) {
//     if (!_auth.isAuthenticated || _auth.userId == null || _auth.email == null) {
//       return null;
//     }

//     var stream = _subscriptionManager
//         .findStreamById(
//           format: "Raw",
//           contextKey: "COMPONENT#GROUP",
//           typeKey: "ACCOUNT",
//           typeId: accountId,
//         )
//         ?.map(_groupsTransformer);

//     if (stream != null) return stream;

//     _channel.sink.add(
//       json.encode(
//         {
//           "action": "Subscribe",
//           "format": "Raw",
//           "contextKey": "COMPONENT#GROUP",
//           "typeKey": "ACCOUNT",
//           "typeId": accountId,
//         },
//       ),
//     );

//     _subscriptionManager.saveSubscriptionId(
//       format: "Raw",
//       contextKey: "COMPONENT#GROUP",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     stream = _subscriptionManager
//         .findStreamById(
//           format: "Raw",
//           contextKey: "COMPONENT#GROUP",
//           typeKey: "ACCOUNT",
//           typeId: accountId,
//         )
//         ?.map(_groupsTransformer);

//     log('getGroupsStream: $stream');
//     return stream;
//   }
// }
