import 'package:freezed_annotation/freezed_annotation.dart';

import 'component_status_entry.dart';
import 'status_option.dart';

part 'device_status_power_source.freezed.dart';
part 'device_status_power_source.g.dart';

@freezed
class DeviceStatusPowerSource with _$DeviceStatusPowerSource {
  factory DeviceStatusPowerSource({
    required ComponentStatusEntry currentSource,
  }) = _DeviceStatusPowerSource;

  factory DeviceStatusPowerSource.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusPowerSourceFromJson(json);

  const DeviceStatusPowerSource._();

  bool get isHealthy => !hasError && !hasWarning;

  bool get hasError {
    return [
      currentSource.state,
    ].contains(StatusOption.error);
  }

  bool get hasWarning {
    return [currentSource.state].contains(StatusOption.warning);
  }

  StatusOption get state {
    return getOverallState([
      currentSource.state,
    ]);
  }
}
