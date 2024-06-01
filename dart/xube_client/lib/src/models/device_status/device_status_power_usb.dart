import 'package:freezed_annotation/freezed_annotation.dart';

import 'component_status_entry.dart';
import 'status_option.dart';

part 'device_status_power_usb.freezed.dart';
part 'device_status_power_usb.g.dart';

@freezed
class DeviceStatusPowerUSB with _$DeviceStatusPowerUSB {
  factory DeviceStatusPowerUSB({
    required ComponentStatusEntry connection,
  }) = _DeviceStatusPowerUSB;

  factory DeviceStatusPowerUSB.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusPowerUSBFromJson(json);

  const DeviceStatusPowerUSB._();

  bool get isHealthy => !hasError && !hasWarning;

  bool get hasError {
    return [
      connection.state,
    ].contains(StatusOption.error);
  }

  bool get hasWarning {
    return [
      connection.state,
    ].contains(StatusOption.warning);
  }

  StatusOption get state {
    return getOverallState([
      connection.state,
    ]);
  }
}
