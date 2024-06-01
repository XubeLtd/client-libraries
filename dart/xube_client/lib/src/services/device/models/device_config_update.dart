import 'package:xube_client/src/models/base_model.dart';

const String stateField = "state";
const String deviceField = "device";
const String approvalField = "approval";

const String updatedField = "updated";
const String updatorField = "updator";

enum ConfigUpdateState {
  waiting_for_device_status,
  ready_to_send,
  sent,
  failed,
  unknown,
}

enum ApprovalState {
  approved,
  denied,
  pending,
  unknown,
}

class Approval {
  ApprovalState state;
  DateTime created;
  DateTime updated;
  String? updator;

  Approval({
    required this.state,
    required this.created,
    required this.updated,
    required this.updator,
  });

  static Approval fromJson(Map<String, dynamic> json) {
    String approvalStateStr = json[stateField];
    ApprovalState state = ApprovalState.values.firstWhere(
      (element) => element.toString() == approvalStateStr,
      orElse: () => ApprovalState.unknown,
    );

    DateTime created;
    DateTime updated;

    try {
      created = DateTime.parse(json[createdField]);
    } catch (e) {
      created = DateTime.now();
    }

    try {
      updated = DateTime.parse(json[updatedField]);
    } catch (e) {
      updated = DateTime.now();
    }

    String? updator = json[updatorField];

    return Approval(
      state: state,
      created: created,
      updated: updated,
      updator: updator,
    );
  }
}

class DeviceConfigUpdate extends BaseModel {
  ConfigUpdateState state;
  String device;
  Approval approval;

  DeviceConfigUpdate({
    required super.version,
    required super.id,
    required this.approval,
    required this.state,
    required this.device,
  });

  static DeviceConfigUpdate fromJson(Map<String, dynamic> json) {
    BaseModel? baseModel = BaseModel.fromJson(json);

    String configUpdateStateStr = json[stateField];
    ConfigUpdateState state = ConfigUpdateState.values.firstWhere(
      (element) => element.toString() == configUpdateStateStr,
      orElse: () => ConfigUpdateState.unknown,
    );

    String device = json[deviceField];
    Approval approval = Approval.fromJson(json[approvalField]);

    return DeviceConfigUpdate(
      state: state,
      device: device,
      approval: approval,
      id: baseModel.id,
      version: baseModel.version,
    );
  }
}
