import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/utils/parse_util.dart';

import 'device_status_connectivity_internet.dart';
import 'device_status_connectivity_cellular.dart';
import 'device_status_connectivity_ethernet.dart';
import 'device_status_connectivity_wifi.dart';

part 'device_status_connectivity.freezed.dart';
part 'device_status_connectivity.g.dart';

@freezed
class DeviceStatusConnectivity with _$DeviceStatusConnectivity {
  factory DeviceStatusConnectivity({
    DeviceStatusConnectivityInternet? internet,
    DeviceStatusConnectivityEthernet? ethernet,
    DeviceStatusConnectivityWifi? wifi,
    DeviceStatusConnectivityCellular? cellular,
  }) = _DeviceStatusConnectivity;

  factory DeviceStatusConnectivity.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusConnectivityFromJson(json);
}
