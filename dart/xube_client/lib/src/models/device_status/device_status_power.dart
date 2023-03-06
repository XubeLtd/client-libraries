import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/models/device_status/device_status_power_battery.dart';
import 'package:xube_client/src/models/device_status/device_status_power_source.dart';
import 'package:xube_client/src/models/device_status/device_status_power_usb.dart';
import 'package:xube_client/src/utils/parse_util.dart';

import 'device_status_power_battery.dart';
import 'device_status_power_usb.dart';
import 'device_status_power_source.dart';

part 'device_status_power.freezed.dart';
part 'device_status_power.g.dart';

@freezed
class DeviceStatusPower with _$DeviceStatusPower {
  factory DeviceStatusPower({
    DeviceStatusPowerBattery? battery,
    DeviceStatusPowerUSB? usb,
    DeviceStatusPowerSource? source,
  }) = _DeviceStatusPower;

  factory DeviceStatusPower.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusPowerFromJson(json);
}
