import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:xube_client/src/models/device_status/component_status_entry.dart';
import 'package:xube_client/src/models/device_status/status_option.dart';
import 'package:xube_client/src/models/group/group_tracked_status.dart';

part 'group.freezed.dart';
part 'group.g.dart';

@freezed
class Group with _$Group {
  factory Group({
    dynamic links,
    String? updater,
    dynamic updates,
    String? version,
    String? SKGSI1,
    String? creator,
    dynamic config,
    String? status,
    String? created,
    String? name,
    String? vComponent,
    String? state,
    String? updated,
    String? v,
    String? account,
    String? SK,
    String? PK,
    String? PKGSI1,
    String? id,
    String? exposure,
    String? type,
    Map<String, GroupTrackedStatus>? trackedStatus,
  }) = _Group;

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Group._();

  List<ComponentStatusEntry> get statusSummary {
    int errors = 0;
    int warnings = 0;

    for (GroupTrackedStatus element in trackedStatus?.values.toList() ?? []) {
      errors += element.numOfErrors;
      warnings += element.numOfWarnings;
    }

    return [
      if (errors > 0)
        ComponentStatusEntry(
          state: StatusOption.error,
          property: 'errors',
          value: errors.toString(),
        ),
      if (warnings > 0)
        ComponentStatusEntry(
          state: StatusOption.warning,
          property: 'warning',
          value: warnings.toString(),
        ),
      if (errors == 0 && warnings == 0)
        ComponentStatusEntry(
          state: StatusOption.healthy,
          property: 'healthy',
          value: 'Healthy',
        ),
    ];
  }
}
