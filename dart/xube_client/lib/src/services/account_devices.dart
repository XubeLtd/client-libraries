import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:xube_client/src/models/account_device.dart';
import 'package:xube_client/src/services/base_client.dart';
import 'package:xube_client/src/utils/path.dart';
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/src/utils/xube_log.dart';
import 'package:xube_client/xube_client.dart';

class XubeClientAccountDevices extends BaseClient {
  final SubscriptionManager _subscriptionManager;
  final XubeLog _log;

  static const String _accountKey = '{account}';
  static const String _accountSubscriptionUrl =
      '/devices/accounts/{$_accountKey}/subscribe';

  XubeClientAccountDevices({
    SubscriptionManager? subscriptionManager,
    XubeLog? log,
  })  : _subscriptionManager = GetIt.I<SubscriptionManager>(),
        _log = XubeLog.getInstance();

  void unsubscribe(String accountId) {
    _subscriptionManager.unsubscribe(
      path: getAccountDevicesSubscriptionPath(accountId),
    );
  }

  Stream<AccountDevices>? getAccountDevicesStream(String accountId) {
    _log.info('Getting account devices stream for account: $accountId');

    String subscriptionPath = getAccountDevicesSubscriptionPath(accountId);
    _log.info('Subscription path: $subscriptionPath');

    return getStream(subscriptionPath, AccountDevices.fromJson);
  }

  String getAccountDevicesSubscriptionPath(String accountId) {
    return substitutePathParameters(
      {_accountKey: accountId},
      _accountSubscriptionUrl,
    );
  }

  List<Device> _accountDevicesListTransformer(dynamic event) {
    List<Device> devices = [];

    final items = (event['items'] as List);
    log('debug _accountDevicesListTransformer items: ${items.length}');

    if (items.isNotEmpty) {
      devices = items.map((e) => Device.fromJson(e)).toList();
    }
    log('debug _accountDevicesListTransformer devices: ${devices.length}');
    devices = [..._getMostRecentDeviceVersions(devices)];

    return devices;
  }

  List<Device> _getMostRecentDeviceVersions(List<Device> devices) {
    Map<String, Device> mostRecentDevices = {};
    for (var device in devices) {
      final tempDevice = mostRecentDevices[device.id];
      if (tempDevice == null) {
        if (device.id != null) {
          mostRecentDevices.putIfAbsent(device.id!, () => device);
        }
        continue;
      }

      if (tempDevice.version < device.version) {
        mostRecentDevices[device.id!] = device;
      }
    }

    return mostRecentDevices.values.toList();
  }
}
