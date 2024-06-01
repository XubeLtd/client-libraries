// import 'dart:convert';
// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:xube_client/src/utils/subscription_manager.dart';
// import 'package:xube_client/xube_client.dart';

// class XubeClientDeviceComponents {
//   final WebSocketChannel _channel;
//   final XubeClientAuth _auth;
//   final SubscriptionManager _subscriptionManager;

//   XubeClientDeviceComponents({
//     required WebSocketChannel channel,
//     required XubeClientAuth auth,
//     SubscriptionManager? subscriptionManager,
//   })  : _channel = channel,
//         _auth = auth,
//         _subscriptionManager =
//             subscriptionManager ?? SubscriptionManager.instance;

//   final dio = Dio();

//   void unsubscribe(String deviceId) {
//     json.encode({
//       "action": "Unsubscribe",
//       "format": "View",
//       "contextKey": "COMPONENT",
//       "typeKey": "DEVICE",
//       "typeId": deviceId,
//     });

//     _subscriptionManager.unsubscribe(
//       format: "View",
//       contextKey: "COMPONENT",
//       typeKey: "DEVICE",
//       typeId: deviceId,
//     );
//   }

//   Stream? getDeviceComponentsStream(String deviceId) {
//     if (!_auth.isAuthenticated || _auth.userId == null || _auth.email == null) {
//       return null;
//     }

//     var stream = _subscriptionManager.findStreamById(
//       format: "View",
//       contextKey: "COMPONENT",
//       typeKey: "DEVICE",
//       typeId: deviceId,
//     );

//     if (stream != null) return stream;

//     log('getDeviceStream: subscribing to $deviceId');
//     _channel.sink.add(
//       json.encode({
//         "action": "Subscribe",
//         "format": "View",
//         "contextKey": "COMPONENT",
//         "typeKey": "DEVICE",
//         "typeId": deviceId,
//       }),
//     );

//     _subscriptionManager.saveSubscriptionId(
//       format: "View",
//       contextKey: "COMPONENT",
//       typeKey: "DEVICE",
//       typeId: deviceId,
//     );

//     stream = _subscriptionManager.findStreamById(
//       format: "View",
//       contextKey: "COMPONENT",
//       typeKey: "DEVICE",
//       typeId: deviceId,
//     );

//     log('getDeviceComponentsStream: $stream');
//     return stream;
//   }

//   Future<void> addDeviceComponentToDevice({
//     required List<String> componentIds,
//     required String accountId,
//     required String deviceId,
//     required String connectionState,
//   }) async {
//     const url = '/deviceComponent';

//     try {
//       final data = {
//         'component': componentIds.first,
//         'account': accountId,
//         'device': deviceId,
//         connectionState: connectionState,
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
// }
