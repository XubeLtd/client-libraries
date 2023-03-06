import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/utils/parse_util.dart';

import 'component_status_entry.dart';

part 'device_status_power_battery.freezed.dart';
part 'device_status_power_battery.g.dart';

@freezed
class DeviceStatusPowerBattery with _$DeviceStatusPowerBattery {
  factory DeviceStatusPowerBattery({
    required ComponentStatusEntry chargingState,
    required ComponentStatusEntry charge,
  }) = _DeviceStatusPowerBattery;

  factory DeviceStatusPowerBattery.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusPowerBatteryFromJson(json);
}
