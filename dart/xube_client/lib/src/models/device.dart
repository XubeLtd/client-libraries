import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/utils/parse_util.dart';

import 'device_status/device_status.dart';

part 'device.freezed.dart';
part 'device.g.dart';

@freezed
class Device with _$Device {
  factory Device({
    List<Map<String, dynamic>>? links,
    String? updater,
    List<Map<String, dynamic>>? updates,
    String? sKGSI1,
    Map<String, dynamic>? currentConfig,
    String? generation,
    String? sKGSI2,
    DeviceStatus? status,
    String? name,
    String? state,
    Map<String, dynamic>? files,
    String? v,
    String? sK,
    String? id,
    String? batch,
    String? model,
    @JsonKey(fromJson: ParseUtil.toInt) @Default(1) int version,
    String? creator,
    String? manufactured,
    Map<String, dynamic>? config,
    String? created,
    String? deviceModel,
    String? vComponent,
    Map<String, dynamic>? base,
    String? make,
    Map<String, dynamic>? capabilities,
    String? updated,
    String? pKGSI2,
    String? manufacturer,
    String? orderState,
    String? account,
    String? pK,
    String? pKGSI1,
    String? exposure,
    String? type,
  }) = _Device;

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
}

/* 
1. Clear devices from account: DEMO
2. Create new devices with the updated device model/schema that includes the 'expected' field
*/