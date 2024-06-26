library xube_client;

import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xube_client/src/utils/jwt_decoder.dart';
import 'package:xube_client/src/utils/submit.dart';
import 'package:xube_client/src/utils/xube_log.dart';

class User {
  final String? userId;
  final String? email;
  final String? token;
  final DateTime? expiryDate;

  User({
    this.userId,
    this.email,
    this.token,
    this.expiryDate,
  });
}

class XubeClientAuth {
  String? _token;
  String? _refreshToken;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;

  static const Duration expiryRefreshOffset = Duration(minutes: 10);
  static const userDataKey = 'userData';

  final XubeLog _log;

  final _authStreamController = StreamController<User?>.broadcast();
  Stream<User?> get authStream => _authStreamController.stream;

  bool get isAuthenticated => token != null;

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  String? get email => _email;
  String? get userId => _userId;

  XubeClientAuth() : _log = XubeLog.getInstance() {
    _setAuthForRequests();
  }

  Future<dynamic> signUp(
    String email,
    String password,
  ) async {
    _log.info('Signing up user');

    _log.info(
        'First, logging out just in case user got here in a strange way.');
    await logout();

    const path = '/auth/sign-up';
    try {
      final responseData = await submit(data: {
        'email': email,
        'password': password,
      }, path: path, requiresAuthentication: false);

      return responseData;
    } catch (error) {
      _log.error('Error occurred when signing up', error: error);
      rethrow;
    }
  }

  Future<void> logIn(String email, String password) async {
    const path = '/auth/log-in';

    try {
      final responseData = await submit(
        data: {
          'email': email,
          'password': password,
        },
        path: path,
        requiresAuthentication: false,
      );

      final String token = responseData['token'] ?? '';
      final String refreshToken = responseData['refreshToken'] ?? '';

      if (token.isEmpty || refreshToken.isEmpty) {
        _log.error('Token or refresh token is empty');
        return;
      }

      _setUserData(
        token,
        refreshToken: refreshToken,
        email: email,
      );
      _prepareAutoRefreshLogin();

      _notifyListeners();
    } catch (error) {
      _log.error('Error occurred when logging in', error: error);
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    User? user = await _fetchUserData();
    if (user == null) {
      _log.warning(
        'Could not auto login - no user data found. User must login',
      );

      return false;
    }

    DateTime? expiry = user.expiryDate;
    if (expiry == null) {
      _log.warning(
        'Could not auto login - no expiry date found. User must login',
      );

      return false;
    }

    if (expiry.isBefore(DateTime.now().subtract(expiryRefreshOffset))) {
      await _refreshLogin();
      return true;
    }

    _notifyListeners();
    _prepareAutoRefreshLogin();

    return true;
  }

  Future<void> logout() async {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;

    _authTimer?.cancel();
    _authTimer = null;

    _notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove(userDataKey);
  }

  Future<void> _refreshLogin() async {
    String path = "/auth/refresh";

    await GetIt.I<Dio>().post(
      path,
      data: {
        "refreshToken": _refreshToken,
      },
    ).then((response) async {
      await _setUserData(response.data['token']);
      _prepareAutoRefreshLogin();
      _notifyListeners();
    }).catchError((error) {
      _log.error(
        'Error occurred when refreshing login. Forcing Logout',
        error: error,
      );
      logout();
    });
  }

  Future<void> _setUserData(
    String token, {
    String? refreshToken,
    String? email,
  }) async {
    if (token.isEmpty) {
      _log.error('Token is empty or null');
    }

    _token = token;
    _refreshToken = refreshToken ?? _refreshToken;
    _email = email ?? _email;

    final payload = parseJwtPayLoad(token);

    _userId = payload['cognito:username'];
    _expiryDate = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);

    await _storeUserData();
  }

  Future<void> _storeUserData() async {
    final prefs = SharedPreferences.getInstance();
    final userData = json.encode(
      {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
        'refreshToken': _refreshToken,
      },
    );

    prefs.then((value) => value.setString(userDataKey, userData));
  }

  void _setAuthForRequests() {
    GetIt.I<Dio>().interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (isAuthenticated) {
          options.headers['Authorization'] = 'Bearer $_token';
        }

        return handler.next(options);
      },
    ));
  }

  Future<User?> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(userDataKey)) {
      throw Exception('No user data found');
    }

    String? rawUserData = prefs.getString(userDataKey);

    if (rawUserData == null) {
      _log.warning(
        'Could not fetch user data. User may have never logged in or this is a new install',
      );
      return null;
    }

    final extractedUserData = json.decode(rawUserData);
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    _token = extractedUserData['token'];
    _email = extractedUserData['email'];
    _userId = extractedUserData['userId'];
    _refreshToken = extractedUserData['refreshToken'];
    _expiryDate = expiryDate;

    return User(
      userId: _userId,
      token: _token,
      email: _email,
      expiryDate: _expiryDate,
    );
  }

  void _prepareAutoRefreshLogin() {
    _authTimer?.cancel();

    final timeToExpiry = _expiryDate!
        .difference(DateTime.now().subtract(expiryRefreshOffset))
        .inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), _refreshLogin);
  }

  void _notifyListeners() {
    if (_userId == null || _token == null || _email == null) {
      _authStreamController.add(null);
      return;
    }

    _authStreamController.add(
      User(
        userId: _userId,
        token: _token,
        email: _email,
        expiryDate: _expiryDate,
      ),
    );
  }
}
