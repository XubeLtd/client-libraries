library xube_client;

// 3rd-Party Packages
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Utilities
import 'package:xube_client/src/utils/subscription_manager.dart';

// Services
import 'package:xube_client/src/services/auth.dart';
import 'package:xube_client/src/services/account.dart';
import 'package:xube_client/src/services/user-accounts.dart';
import 'package:xube_client/src/utils/xube_log.dart';
export 'package:xube_client/src/services/auth.dart';

class XubeClient {
  late final XubeClientAuth _auth;
  late final XubeClientUserAccounts _userAccounts;
  late final XubeClientAccount _account;

  XubeClientAuth get auth => _auth;
  XubeClientUserAccounts get userAccounts => _userAccounts;
  XubeClientAccount get account => _account;

  XubeClient({
    required String baseApiUrl,
    required String baseSocketUrl,
    XubeClientAuth? auth,
    XubeClientUserAccounts? userAccounts,
    XubeClientAccount? account,
    XubeLog? log,
  }) {
    log ??= XubeLog.getInstance();
    log.initialize(
        applicationVersion: '0.0.1',
        platformDiagnosticsUrl: '/app/diagnostics',
        minimumPrintLevel: 0,
        minimumSendDiagnosticsLevel: XubeLogLevel.error);
    log.info('Initializing Xube Client');

    final getIt = GetIt.I;
    if (!getIt.isRegistered<XubeClientAuth>()) {
      getIt.registerLazySingleton<XubeClientAuth>(
        () => _auth = XubeClientAuth(),
      );
    }

    if (!getIt.isRegistered<Dio>()) {
      getIt.registerLazySingleton<Dio>(
        () => Dio(
          BaseOptions(
              baseUrl: baseApiUrl,
              contentType: 'application/json',
              headers: {
                'Access-Control-Allow-Origin': '*',
                'Access-Control-Allow-Methods':
                    'GET, POST, PUT, DELETE, OPTIONS',
                'Access-Control-Allow-Headers': '*',
                'Access-Control-Allow-Credentials': 'true',
              }),
        ),
      );
    }
    if (!getIt.isRegistered<SubscriptionManager>()) {
      getIt.registerLazySingleton<SubscriptionManager>(
        () => SubscriptionManager(
          baseApiUrl,
          baseSocketUrl,
          log,
        ),
      );
    }

    _userAccounts = userAccounts ?? XubeClientUserAccounts();
  }
}
