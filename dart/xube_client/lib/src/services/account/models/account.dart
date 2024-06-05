import 'dart:developer';

import 'package:xube_client/src/models/base_model.dart';

const String accountField = "account";

class Account extends BaseModel {
  String name;

  Account({
    required this.name,
    required super.version,
    required super.id,
  });

  static Account fromJson(Map<String, dynamic> json) {
    log('Account.fromJson: $json');

    String name = json['accountName'];
    BaseModel model = BaseModel.fromJson(json);

    // if (name == null || model == null) {
    //   XubeLog.getInstance().error('Account.fromJson: Invalid data');
    //   return null;
    // }

    return Account(
      name: name,
      id: model.id,
      version: model.version,
    );
  }
}
