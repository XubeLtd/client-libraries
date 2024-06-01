import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/models/device_status/device_status_power.dart';

import 'device_status_connectivity.dart';
import 'device_status_status.dart';

part 'device_status.freezed.dart';
part 'device_status.g.dart';

@freezed
class DeviceStatus with _$DeviceStatus {
  factory DeviceStatus({
    DeviceStatusStatus? status,
    required DeviceStatusConnectivity connectivity,
    required DeviceStatusPower power,
  }) = _DeviceStatus;

  factory DeviceStatus.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusFromJson(json);
}
