library xube_client;

// 3rd-Party Packages
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:xube_client/src/services/account_devices.dart';

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
  late final XubeClientAccount _account;
  late final XubeClientAccountDevices _accountDevices;
  late final XubeClientUserAccounts _userAccounts;

  XubeClientAuth get auth => _auth;
  XubeClientAccount get account => _account;
  XubeClientAccountDevices get accountDevices => _accountDevices;
  XubeClientUserAccounts get userAccounts => _userAccounts;

  XubeClient({
    required String baseApiUrl,
    required String baseSocketUrl,
    XubeClientAuth? auth,
    XubeClientAccountDevices? accountDevices,
    XubeClientAccount? account,
    XubeClientUserAccounts? userAccounts,
    XubeLog? log,
  }) {
    log ??= XubeLog.getInstance();
    log.initialize(
        applicationVersion: '0.0.1',
        platformDiagnosticsUrl: '/diagnostics',
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

    _account = account ?? XubeClientAccount();
    _accountDevices = accountDevices ?? XubeClientAccountDevices();
    _userAccounts = userAccounts ?? XubeClientUserAccounts();
  }
}
