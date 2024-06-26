// import 'dart:convert';
// import 'dart:developer';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:xube_client/src/utils/subscription_manager.dart';
// import 'package:xube_client/xube_client.dart';

// class XubeClientDevices {
//   final WebSocketChannel _channel;
//   final XubeClientAuth _auth;
//   final SubscriptionManager _subscriptionManager;

//   XubeClientDevices({
//     required WebSocketChannel channel,
//     required XubeClientAuth auth,
//     SubscriptionManager? subscriptionManager,
//   })  : _channel = channel,
//         _auth = auth,
//         _subscriptionManager =
//             subscriptionManager ?? SubscriptionManager.instance;

//   void unsubscribe(String projectId) {
//     _channel.sink.add(
//       json.encode(
//         {
//           "action": "Unsubscribe",
//           "format": "View",
//           "contextKey": "DEVICE",
//           "typeKey": "PROJECT",
//           "typeId": projectId,
//         },
//       ),
//     );

//     _subscriptionManager.unsubscribe(
//       format: "View",
//       contextKey: "DEVICE",
//       typeKey: "PROJECT",
//       typeId: projectId,
//     );
//   }

//   Stream? getProjectDevicesStream(String projectId) {
//     if (!_auth.isAuthenticated || _auth.userId == null || _auth.email == null) {
//       return null;
//     }

//     var stream = _subscriptionManager.findStreamById(
//       format: "View",
//       contextKey: "DEVICE",
//       typeKey: "PROJECT",
//       typeId: projectId,
//     );

//     if (stream != null) return stream;

//     _channel.sink.add(
//       json.encode(
//         {
//           "action": "Subscribe",
//           "format": "View",
//           "contextKey": "DEVICE",
//           "typeKey": "PROJECT",
//           "typeId": projectId,
//         },
//       ),
//     );

//     _subscriptionManager.saveSubscriptionId(
//       format: "View",
//       contextKey: "DEVICE",
//       typeKey: "PROJECT",
//       typeId: projectId,
//     );

//     stream = _subscriptionManager.findStreamById(
//       format: "View",
//       contextKey: "DEVICE",
//       typeKey: "PROJECT",
//       typeId: projectId,
//     );

//     log('getProjectDevicesStream: $stream');
//     return stream;
//   }

//   Future<void> linkDeviceToProject({
//     required List<String> deviceIds,
//     required String projectId,
//   }) async {
//     const url = '/devices/project';

//     try {
//       final data = {
//         'deviceIDs': deviceIds,
//         'projectID': projectId,
//       };

//       await submit(
//         data: data,
//         path: url,
//         authToken: _auth.token,
//         method: 'put',
//       );
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<List<Device>> getAccountDevices(String accountId) async {
//     List<Device> devices = [];

//     if (!_auth.isAuthenticated || _auth.userId == null || _auth.email == null) {
//       return devices;
//     }

//     const url = '/devices/account';

//     try {
//       final responseData = await submit(
//         data: {'account': accountId, 'format': 'Raw'},
//         path: url,
//         authToken: _auth.token,
//         method: 'get',
//       );

//       log('responseData: $responseData');

//       final List<dynamic> rawDevices =
//           responseData.data['accountDevices'] ?? [];

//       devices = rawDevices
//           .map((e) => Device.fromJson(e as Map<String, dynamic>))
//           .toList();

//       return devices;
//     } catch (error) {
//       rethrow;
//     }
//   }
// }
