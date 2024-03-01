import 'package:xube_client/src/models/base_model.dart';
import 'package:xube_client/src/utils/xube_log.dart';
import 'package:xube_client/xube_client.dart';

class AccountUser extends BaseModel {
  String account;
  String email;

  AccountUser({
    required this.account,
    required this.email,
    required super.version,
    required super.id,
  });

  static AccountUser? fromJson(Map<String, dynamic> json) {
    String? account = json[accountField];
    String? email = json[emailField];

    BaseModel? model = BaseModel.fromJson(json);

    if (account == null || email == null || model == null) {
      XubeLog.getInstance().error('AccountUser.fromJson: Invalid data. $json');
      return null;
    }

    return AccountUser(
      account: account,
      email: email,
      id: model.id,
      version: model.version,
    );
  }
}

class AccountUsers {
  List<AccountUser> accountUsers;

  AccountUsers({required this.accountUsers});

  static AccountUsers fromJson(dynamic json) {
    List<AccountUser> accountUsers = [];

    if (json is! List) {
      XubeLog.getInstance().error('Account Users JSON is not a list');
      return AccountUsers(accountUsers: accountUsers);
    }

    for (Map<String, dynamic> accountUserMap in json) {
      AccountUser? accountUser = AccountUser.fromJson(accountUserMap);

      if (accountUser == null) {
        continue;
      }

      accountUsers.add(accountUser);
    }

    return AccountUsers(accountUsers: accountUsers);
  }
}
