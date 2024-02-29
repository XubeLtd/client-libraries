import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:xube_client/src/models/account_user.dart';
import 'package:xube_client/src/services/base_client.dart';
import 'package:xube_client/src/utils/path.dart';
import 'package:xube_client/src/utils/submit.dart';
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/src/utils/xube_log.dart';
import 'package:xube_client/xube_client.dart';

class XubeClientUserAccounts extends BaseClient {
  final SubscriptionManager _subscriptionManager;
  final XubeLog _log;

  static const String _userKey = '{user}';
  static const String _userAccountsSubscriptionUrl =
      '/accounts/users/{$_userKey}/subscribe';

  XubeClientUserAccounts({
    SubscriptionManager? subscriptionManager,
    XubeLog? log,
  })  : _subscriptionManager = GetIt.I<SubscriptionManager>(),
        _log = XubeLog.getInstance();

  void unsubscribe() {
    String? email = GetIt.I<XubeClientAuth>().email;

    if (email == null) {
      _log.error(
          'No email found for auth client when unsubscribing from User Accounts');
      return;
    }

    _subscriptionManager.unsubscribe(
      path: getUserAccountsSubscriptionPath(email),
    );
  }

  Stream<AccountUsers>? getUserAccountsStream() {
    XubeClientAuth auth = GetIt.I<XubeClientAuth>();

    String? email = auth.email;

    if (email == null) {
      _log.warning('Could not get user email from auth');
      return null;
    }

    _log.info('Getting user accounts stream for email: $email');

    String subscriptionPath = getUserAccountsSubscriptionPath(email);
    _log.info('Subscription path: $subscriptionPath');

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

  Future<void> createAccount(String accountName) async {
    const path = '/accounts';

    try {
      final responseData = await submit(
        data: {
          'name': accountName,
        },
        path: path,
      );

      _log.info('createAccount responseData: $responseData');
    } catch (e) {
      rethrow;
    }
  }
}
