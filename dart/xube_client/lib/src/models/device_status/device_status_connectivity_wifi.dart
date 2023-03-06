import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/utils/parse_util.dart';

import 'component_status_entry.dart';

part 'device_status_connectivity_wifi.freezed.dart';
part 'device_status_connectivity_wifi.g.dart';

@freezed
class DeviceStatusConnectivityWifi with _$DeviceStatusConnectivityWifi {
  factory DeviceStatusConnectivityWifi({
    required ComponentStatusEntry connection,
    required ComponentStatusEntry authentication,
    required ComponentStatusEntry signalStrength,
  }) = _DeviceStatusConnectivityWifi;

  factory DeviceStatusConnectivityWifi.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusConnectivityWifiFromJson(json);
}
