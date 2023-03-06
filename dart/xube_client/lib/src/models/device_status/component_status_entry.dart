import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/utils/parse_util.dart';

part 'component_status_entry.freezed.dart';
part 'component_status_entry.g.dart';

@freezed
class ComponentStatusEntry with _$ComponentStatusEntry {
  factory ComponentStatusEntry({
    String? occured,
    required String state,
    required String property,
    required String value,
    String? message,
  }) = _ComponentStatusEntry;

  factory ComponentStatusEntry.fromJson(Map<String, dynamic> json) =>
      _$ComponentStatusEntryFromJson(json);
}
