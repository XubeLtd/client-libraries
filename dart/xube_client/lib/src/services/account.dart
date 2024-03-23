import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:xube_client/src/models/account.dart';
import 'package:xube_client/src/services/base_client.dart';
import 'package:xube_client/src/utils/subscription_manager.dart';
import 'package:xube_client/src/utils/xube_log.dart';
import 'package:xube_client/xube_client.dart';

class XubeClientAccount extends BaseClient {
  final SubscriptionManager _subscriptionManager;
  final XubeLog _log;

  XubeClientAccount({
    SubscriptionManager? subscriptionManager,
  })  : _subscriptionManager =
            subscriptionManager ?? GetIt.I<SubscriptionManager>(),
        _log = XubeLog.getInstance();

  void unsubscribe(String accountId) {
    _subscriptionManager.unsubscribe(path: getXubeAccountPath(accountId));
  }

  String getXubeAccountPath(String accountId) {
    return '/accounts/$accountId/subscribe';
  }

  Stream<Account>? getAccountStream(String accountId) {
    _log.info('Getting user accounts stream for email: $accountId');

    String subscriptionPath = getXubeAccountPath(accountId);
    _log.info('Subscription path: $subscriptionPath');

    return getStream(subscriptionPath, Account.fromJson);
  }

  Future<void> addUserToAccount(
    String userEmail,
    String accountId,
    Map<String, bool> accountRoles,
  ) async {
    List<String> roles = [];

    accountRoles.forEach((key, value) {
      if (value) roles.add(key);
    });

    const url = '/accounts/user';
    try {
      final responseData = await submit(
        data: {
          'email': userEmail,
          'roles': roles,
          'account': accountId,
        },
        path: url,
      );

      log('addUserToAccount responseData: $responseData');
    } catch (error) {
      rethrow;
    }
  }
}
