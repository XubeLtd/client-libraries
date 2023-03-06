import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/utils/parse_util.dart';

import 'component_status_entry.dart';

part 'device_status_status.freezed.dart';
part 'device_status_status.g.dart';

@freezed
class DeviceStatusStatus with _$DeviceStatusStatus {
  factory DeviceStatusStatus({
    required ComponentStatusEntry errors,
    required ComponentStatusEntry warnings,
    ComponentStatusEntry? nextUpdate,
    required ComponentStatusEntry lastUpdate,
  }) = _DeviceStatusStatus;

  factory DeviceStatusStatus.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusStatusFromJson(json);
}
