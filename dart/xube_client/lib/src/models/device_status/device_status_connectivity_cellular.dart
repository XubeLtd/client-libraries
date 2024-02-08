import 'package:freezed_annotation/freezed_annotation.dart';

import 'component_status_entry.dart';

part 'device_status_connectivity_cellular.freezed.dart';
part 'device_status_connectivity_cellular.g.dart';

@freezed
class DeviceStatusConnectivityCellular with _$DeviceStatusConnectivityCellular {
  factory DeviceStatusConnectivityCellular({
    required ComponentStatusEntry connection,
    required ComponentStatusEntry signalStrength,
  }) = _DeviceStatusConnectivityCellular;

  factory DeviceStatusConnectivityCellular.fromJson(
          Map<String, dynamic> json) =>
      _$DeviceStatusConnectivityCellularFromJson(json);
}
