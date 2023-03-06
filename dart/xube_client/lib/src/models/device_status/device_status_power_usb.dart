import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/utils/parse_util.dart';

import 'component_status_entry.dart';

part 'device_status_power_usb.freezed.dart';
part 'device_status_power_usb.g.dart';

@freezed
class DeviceStatusPowerUSB with _$DeviceStatusPowerUSB {
  factory DeviceStatusPowerUSB({
    required ComponentStatusEntry connection,
  }) = _DeviceStatusPowerUSB;

  factory DeviceStatusPowerUSB.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusPowerUSBFromJson(json);
}
