import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/models/device_status/component_status_entry.dart';
import 'package:xube_client/src/models/device_status/status_option.dart';

part 'group_tracked_status.freezed.dart';
part 'group_tracked_status.g.dart';

@freezed
class GroupTrackedStatus with _$GroupTrackedStatus {
  factory GroupTrackedStatus({
    required List<ComponentStatusEntry> errors,
    required List<ComponentStatusEntry> warnings,
  }) = _GroupTrackedStatus;

  factory GroupTrackedStatus.fromJson(Map<String, dynamic> json) =>
      _$GroupTrackedStatusFromJson(json);

  GroupTrackedStatus._();

  int get numOfErrors {
    int value = 0;

    for (var error in errors) {
      final temp = int.tryParse(error.value) ?? 0;
      value += temp;
    }

    return value;
  }

  int get numOfWarnings {
    int value = 0;

    for (var warning in warnings) {
      final temp = int.tryParse(warning.value) ?? 0;
      value += temp;
    }

    return value;
  }
}
