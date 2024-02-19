// import 'dart:convert';
// import 'dart:developer';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:xube_client/src/utils/subscription_manager.dart';
// import 'package:xube_client/xube_client.dart';
// import 'package:http/http.dart' as http;

// class XubeClientAccountDevices {
//   final WebSocketChannel _channel;
//   final XubeClientAuth _auth;
//   final SubscriptionManager _subscriptionManager;

//   XubeClientAccountDevices({
//     required WebSocketChannel channel,
//     required XubeClientAuth auth,
//     SubscriptionManager? subscriptionManager,
//   })  : _channel = channel,
//         _auth = auth,
//         _subscriptionManager =
//             subscriptionManager ?? SubscriptionManager.instance;

//   void unsubscribe(String accountId) {
//     http.post()
//     // _channel.sink.add(
//     //   json.encode(
//     //     {
//     //       "action": "Unsubscribe",
//     //       "format": "Raw",
//     //       "contextKey": "COMPONENT#DEVICE",
//     //       "typeKey": "ACCOUNT",
//     //       "typeId": accountId,
//     //     },
//     //   ),
//     // );

//     _subscriptionManager.unsubscribe(
//       format: "Raw",
//       contextKey: "COMPONENT#DEVICE",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );
//   }

//   Stream<List<Device>>? getAccountDevicesStream(String accountId) {
//     if (!_auth.isAuthenticated || _auth.userId == null || _auth.email == null) {
//       return null;
//     }

//     var stream = _subscriptionManager
//         .findStreamById(
//           format: "Raw",
//           contextKey: "COMPONENT#DEVICE",
//           typeKey: "ACCOUNT",
//           typeId: accountId,
//         )
//         ?.map(_accountDevicesListTransformer);

//     if (stream != null) return stream;

//     _channel.sink.add(
//       json.encode(
//         {
//           "action": "Subscribe",
//           "format": "Raw",
//           "contextKey": "COMPONENT#DEVICE",
//           "typeKey": "ACCOUNT",
//           "typeId": accountId,
//         },
//       ),
//     );

//     _subscriptionManager.saveSubscriptionId(
//       format: "Raw",
//       contextKey: "COMPONENT#DEVICE",
//       typeKey: "ACCOUNT",
//       typeId: accountId,
//     );

//     stream = _subscriptionManager
//         .findStreamById(
//           format: "Raw",
//           contextKey: "COMPONENT#DEVICE",
//           typeKey: "ACCOUNT",
//           typeId: accountId,
//         )
//         ?.map(_accountDevicesListTransformer);

//     log('getAccountDevicesStream: $stream');
//     return stream;
//   }

//   List<Device> _accountDevicesListTransformer(dynamic event) {
//     List<Device> devices = [];

//     final items = (event['items'] as List);
//     log('debug _accountDevicesListTransformer items: ${items.length}');

//     if (items.isNotEmpty) {
//       devices = items.map((e) => Device.fromJson(e)).toList();
//     }
//     log('debug _accountDevicesListTransformer devices: ${devices.length}');
//     devices = [..._getMostRecentDeviceVersions(devices)];

//     return devices;
//   }

//   List<Device> _getMostRecentDeviceVersions(List<Device> devices) {
//     Map<String, Device> mostRecentDevices = {};
//     for (var device in devices) {
//       final tempDevice = mostRecentDevices[device.id];
//       if (tempDevice == null) {
//         if (device.id != null) {
//           mostRecentDevices.putIfAbsent(device.id!, () => device);
//         }
//         continue;
//       }

//       if (tempDevice.version < device.version) {
//         mostRecentDevices[device.id!] = device;
//       }
//     }

//     return mostRecentDevices.values.toList();
//   }
// }
