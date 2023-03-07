import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/utils/parse_util.dart';

import 'status_option.dart';

part 'component_status_entry.freezed.dart';
part 'component_status_entry.g.dart';

@freezed
class ComponentStatusEntry with _$ComponentStatusEntry {
  factory ComponentStatusEntry({
    String? occured,
    @JsonKey(fromJson: statusOptionFromJson) required StatusOption state,
    required String property,
    @JsonKey(fromJson: ParseUtil.intToString) required String value,
    String? message,
  }) = _ComponentStatusEntry;

  factory ComponentStatusEntry.fromJson(Map<String, dynamic> json) =>
      _$ComponentStatusEntryFromJson(json);
}
