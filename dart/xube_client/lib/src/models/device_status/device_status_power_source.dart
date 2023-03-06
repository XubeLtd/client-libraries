import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/utils/parse_util.dart';

import 'component_status_entry.dart';

part 'device_status_power_source.freezed.dart';
part 'device_status_power_source.g.dart';

@freezed
class DeviceStatusPowerSource with _$DeviceStatusPowerSource {
  factory DeviceStatusPowerSource({
    required ComponentStatusEntry currentSource,
  }) = _DeviceStatusPowerSource;

  factory DeviceStatusPowerSource.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusPowerSourceFromJson(json);
}
