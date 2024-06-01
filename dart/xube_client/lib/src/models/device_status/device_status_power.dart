import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/models/device_status/device_status_power_battery.dart';
import 'package:xube_client/src/models/device_status/device_status_power_source.dart';
import 'package:xube_client/src/models/device_status/device_status_power_usb.dart';
import 'package:xube_client/src/models/device_status/status_option.dart';

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

  const DeviceStatusPower._();

  bool get isHealthy => !hasError && !hasWarning;

  bool get hasError {
    return (battery?.hasError ?? false) ||
        (usb?.hasError ?? false) ||
        (source?.hasError ?? false);
  }

  bool get hasWarning {
    return (battery?.hasWarning ?? false) ||
        (usb?.hasWarning ?? false) ||
        (source?.hasWarning ?? false);
  }

  StatusOption get state {
    return getOverallState([
      battery?.state ?? StatusOption.healthy,
      usb?.state ?? StatusOption.healthy,
      source?.state ?? StatusOption.healthy,
    ]);
  }
}
