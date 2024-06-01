import 'package:freezed_annotation/freezed_annotation.dart';

import 'component_status_entry.dart';

part 'device_status_connectivity_ethernet.freezed.dart';
part 'device_status_connectivity_ethernet.g.dart';

@freezed
class DeviceStatusConnectivityEthernet with _$DeviceStatusConnectivityEthernet {
  factory DeviceStatusConnectivityEthernet({
    required ComponentStatusEntry connection,
  }) = _DeviceStatusConnectivityEthernet;

  factory DeviceStatusConnectivityEthernet.fromJson(
          Map<String, dynamic> json) =>
      _$DeviceStatusConnectivityEthernetFromJson(json);
}
