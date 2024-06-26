// import 'dart:developer';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:xube_client/src/utils/subscription_manager.dart';
// import 'package:xube_client/xube_client.dart';

// class XubeClientAccountComponents {
//   final WebSocketChannel _channel;
//   final XubeClientAuth _auth;
//   final SubscriptionManager _subscriptionManager;

//   XubeClientAccountComponents({
//     required WebSocketChannel channel,
//     required XubeClientAuth auth,
//     SubscriptionManager? subscriptionManager,
//   })  : _channel = channel,
//         _auth = auth,
//         _subscriptionManager =
//             subscriptionManager ?? SubscriptionManager.instance;

//   Future<List<Component>> getAccountComponents(String accountId) async {
//     List<Component> components = [];

//     if (!_auth.isAuthenticated || _auth.userId == null || _auth.email == null) {
//       return components;
//     }

//     const url = '/components/account';
//     try {
//       final responseData = await submit(
//         data: {'account': accountId},
//         path: url,
//         authToken: _auth.token,
//         method: 'get',
//       );

//       log('responseData: $responseData');

//       final List<dynamic> rawComponents = responseData.data ?? [];

//       components = rawComponents
//           .map((e) => Component.fromJson(e as Map<String, dynamic>))
//           .toList();

//       return components;
//     } catch (error) {
//       rethrow;
//     }
//   }

//   Future<void> createAccountComponent({
//     required String accountId,
//     required String name,
//   }) async {
//     const url = '/component';

//     try {
//       final data = {
//         'account': accountId,
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
// }
