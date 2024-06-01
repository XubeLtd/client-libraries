import 'package:get_it/get_it.dart';
import 'package:xube_client/src/services/base_service.dart';
import 'package:xube_client/src/utils/path.dart';
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/src/utils/xube_log.dart';
import 'package:xube_client/xube_client.dart';

class XubeAccountService extends BaseService {
  //Path Keys
  static const String _userKey = '{user}';
  static const String _accountKey = '{account}';

  XubeAccountService({
    SubscriptionManager? subscriptionManager,
    XubeLog? log,
  }) : super(subscriptionManager: subscriptionManager, log: log);

  //Features
  Future<void> createAccount(String accountName) async {
    String path = '/accounts';

    try {
      final responseData = await submit(
        data: {
          'name': accountName,
        },
        path: path,
      );

      log.info('createAccount responseData: $responseData');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUserToAccount(String email, final String accountId) async {
    String path = '/accounts/$accountId/users';

    try {
      final responseData = await submit(data: {'user': email}, path: path);

      log.info('add user to account response: $responseData');
    } catch (e) {
      rethrow;
    }
  }

  // ------------------- Account -------------------
  static const String _accountSubscriptionUrl =
      '/accounts/{$_accountKey}/subscribe';

  String getXubeAccountPath(String accountId) => substitutePathParameters(
        {_accountKey: accountId},
        _accountSubscriptionUrl,
      );

  Stream<Account>? getAccountStream(String accountId) {
    log.info('Accounts stream for account: $accountId');

    String subscriptionPath = getXubeAccountPath(accountId);
    log.info('Account Subscription path: $subscriptionPath');

    return getStream(subscriptionPath, Account.fromJson);
  }

  void unsubscribeFromAccount(String accountId) {
    subscriptionManager.unsubscribe(path: getXubeAccountPath(accountId));
  }

  // ---------------- User Accounts ---------------
  static const String _userAccountsSubscriptionUrl =
      '/accounts/users/{$_userKey}/subscribe';

  Stream<AccountUsers>? getUserAccountsStream() {
    XubeClientAuth auth = GetIt.I<XubeClientAuth>();

    String? email = auth.email;

    if (email == null) {
      log.warning('Could not get user email from auth');
      return null;
    }

    log.info('Getting user accounts stream for email: $email');

    String subscriptionPath = getUserAccountsSubscriptionPath(email);
    log.info('User Accounts Subscription path: $subscriptionPath');

    return getStream(
      subscriptionPath,
      AccountUsers.fromJson,
    );
  }

  String getUserAccountsSubscriptionPath(String email) {
    return substitutePathParameters(
      {_userKey: email},
      _userAccountsSubscriptionUrl,
    );
  }

  void unsubscribeFromUserAccounts() {
    String? email = GetIt.I<XubeClientAuth>().email;

    if (email == null) {
      log.error(
          'No email found for auth client when unsubscribing from User Accounts');
      return;
    }

    subscriptionManager.unsubscribe(
      path: getUserAccountsSubscriptionPath(email),
    );
  }

  // ----------------- Account Users ----------------
  static const String _accountUsersSubscriptionUrl =
      '/accounts/{$_accountKey}/users/subscribe';

  Stream<AccountUsers>? getAccountUsersStream(String accountId) {
    String subscriptionPath = getAccountUsersSubscriptionPath(accountId);
    log.info('Account Users Subscription path: $subscriptionPath');

    return getStream(
      subscriptionPath,
      AccountUsers.fromJson,
    );
  }

  String getAccountUsersSubscriptionPath(String accountId) {
    return substitutePathParameters(
      {_accountKey: accountId},
      _accountUsersSubscriptionUrl,
    );
  }
}
