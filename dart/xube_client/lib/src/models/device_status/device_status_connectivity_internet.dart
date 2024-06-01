import 'package:freezed_annotation/freezed_annotation.dart';

import 'component_status_entry.dart';

part 'device_status_connectivity_internet.freezed.dart';
part 'device_status_connectivity_internet.g.dart';

@freezed
class DeviceStatusConnectivityInternet with _$DeviceStatusConnectivityInternet {
  factory DeviceStatusConnectivityInternet({
    required ComponentStatusEntry connection,
    ComponentStatusEntry? latency,
  }) = _DeviceStatusConnectivityInternet;

  factory DeviceStatusConnectivityInternet.fromJson(
          Map<String, dynamic> json) =>
      _$DeviceStatusConnectivityInternetFromJson(json);
}
