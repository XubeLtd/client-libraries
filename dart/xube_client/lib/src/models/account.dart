import 'package:xube_client/src/models/base_model.dart';
import 'package:xube_client/src/utils/xube_log.dart';

class Account extends BaseModel {
  String name;

  Account({
    required this.name,
    required super.version,
    required super.id,
  });

  static Account? fromJson(dynamic json) {
    String? name = json[nameField];
    BaseModel? model = BaseModel.fromJson(json);

    if (name == null || model == null) {
      XubeLog.getInstance().error('Account.fromJson: Invalid data');
      return null;
    }

    return Account(
      name: name,
      id: model.id,
      version: model.version,
    );
  }
}
