import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/utils/parse_util.dart';

import 'component_status_entry.dart';
import 'status_option.dart';

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

  const DeviceStatusPowerBattery._();

  bool get isHealthy => !hasError && !hasWarning;

  bool get hasError {
    return [
      charge.state,
      chargingState.state,
    ].contains(StatusOption.error);
  }

  bool get hasWarning {
    return [
      charge.state,
      chargingState.state,
    ].contains(StatusOption.warning);
  }

  StatusOption get state {
    return getOverallState([
      charge.state,
      chargingState.state,
    ]);
  }
}
