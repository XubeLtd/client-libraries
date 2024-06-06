import 'package:xube_client/src/models/base_model.dart';
import 'package:xube_client/src/utils/xube_log.dart';

const String accountIdField = "accountId";
const String deviceIdField = "deviceId";

class AccountDevice extends BaseModel {
  String account;
  String device;

  AccountDevice({
    required this.account,
    required this.device,
    required super.version,
    required super.id,
  });

  static AccountDevice? fromJson(Map<String, dynamic> json) {
    String? accountId = json[accountIdField];
    String? deviceId = json[deviceIdField];

    BaseModel? model = BaseModel.fromJson(json);

    if (accountId == null || deviceId == null || model == null) {
      XubeLog.getInstance().error(
        'AccountDevices.fromJson: Invalid data. $json',
      );
      return null;
    }

    return AccountDevice(
      account: accountId,
      device: deviceId,
      id: model.id,
      version: model.version,
    );
  }
}

class AccountDevices {
  List<AccountDevice> accountDevices;

  AccountDevices({required this.accountDevices});

  static AccountDevices fromJson(dynamic json) {
    List<AccountDevice> accountDevices = [];

    if (json is! List) {
      XubeLog.getInstance().error('Account Users JSON is not a list');
      return AccountDevices(accountDevices: accountDevices);
    }

    for (Map<String, dynamic> accountDeviceMap in json) {
      AccountDevice? accountDevice = AccountDevice.fromJson(accountDeviceMap);

      if (accountDevice == null) {
        continue;
      }

      accountDevices.add(accountDevice);
    }

    return AccountDevices(accountDevices: accountDevices);
  }
}
