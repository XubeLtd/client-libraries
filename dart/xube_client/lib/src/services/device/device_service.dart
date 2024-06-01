import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:xube_client/src/services/base_service.dart';
import 'package:xube_client/src/services/device/models/device_config_update.dart';
import 'package:xube_client/src/utils/path.dart';
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/src/utils/xube_log.dart';
import 'package:xube_client/xube_client.dart';

class XubeDeviceService extends BaseService {
  //Path Keys
  static const String _deviceKey = '{device}';
  static const String _accountKey = '{account}';

  XubeDeviceService({
    SubscriptionManager? subscriptionManager,
    XubeLog? log,
  }) : super(subscriptionManager: subscriptionManager, log: log);

  // ------------------- Account Devices -------------------
  static const String _accountDevicesSubscriptionUrl =
      '/devices/accounts/{$_accountKey}/subscribe';

  String getAccountDevicesPath(String accountId) => substitutePathParameters(
        {_accountKey: accountId},
        _accountDevicesSubscriptionUrl,
      );

  Stream<AccountDevices>? getAccountDevicesStream(String accountId) {
    log.info('Account Devices stream for account: $accountId');

    String subscriptionPath = getAccountDevicesPath(accountId);
    log.info('Account Devices Subscription path: $subscriptionPath');

    return getStream(subscriptionPath, AccountDevices.fromJson);
  }

  void unsubscribeFromAccountDevices(String accountId) {
    subscriptionManager.unsubscribe(path: getAccountDevicesPath(accountId));
  }

  // -------------------- Device ---------------------
  static const String _deviceSubscriptionUrl =
      '/devices/{$_deviceKey}/subscribe';

  String getDevicePath(String deviceId) => substitutePathParameters(
        {_deviceKey: deviceId},
        _deviceSubscriptionUrl,
      );

  Stream<Device>? getDeviceStream(String deviceId) {
    log.info('Device stream for device $deviceId');

    String subscriptionPath = getDevicePath(deviceId);
    log.info('Device Subscriptino path: $subscriptionPath');

    return getStream(subscriptionPath, Device.fromJson);
  }

  void unsubscribeFromDevice(String deviceId) {
    subscriptionManager.unsubscribe(
      path: getDevicePath(deviceId),
    );
  }

  // ---------------------- Device Config Update --------------------
  static const String _deviceConfigUpdateSubscriptionUrl =
      '/devices/{$_deviceKey}/config/update/subscribe';

  String getDeviceConfigUpdatePath(String deviceId) => substitutePathParameters(
        {_deviceKey: deviceId},
        _deviceConfigUpdateSubscriptionUrl,
      );

  Stream<DeviceConfigUpdate>? getDeviceConfigUpdateStream(String deviceId) {
    log.info('Device config update stream for device $deviceId');

    String subscriptionPath = getDeviceConfigUpdatePath(deviceId);
    log.info('Device Config Update Subscription path: $subscriptionPath');

    return getStream(subscriptionPath, DeviceConfigUpdate.fromJson);
  }

  void unsubscribeFromDeviceConfigUpdate(String deviceId) {
    subscriptionManager.unsubscribe(
      path: getDeviceConfigUpdatePath(deviceId),
    );
  }

  Future<Result> setConfigurationUpdateApproval({
    required ApprovalState state,
    required String deviceId,
  }) async {
    try {
      String setApprovalUrl = '/devices/$deviceId/config/update/approval';

      Response response = await GetIt.I<Dio>().post(
        setApprovalUrl,
        data: {"approval": state.toString()},
      );

      if (response.statusCode == null) {
        return Result(hasError: true);
      }

      return Result(
        data: response.data,
        hasError: response.statusCode! > 300,
      );
    } catch (e) {
      log.error(
          'Error occurred when setting the config update approval for $deviceId. Intention was to set approval to ${state.toString()}');
    }

    return Result(hasError: true);
  }
}
