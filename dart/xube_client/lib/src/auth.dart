library xube_client;

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'jwt_decoder.dart';

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
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;

  final _authStreamController = StreamController<User>.broadcast();

  Stream<User> get authStream => _authStreamController.stream;

  bool get isAuth => token != null;

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

  Future<dynamic> signUp(
    String email,
    String password,
  ) async {
    final url = Uri.parse(
        'https://tcayebnb36.execute-api.eu-west-1.amazonaws.com/prod/user/sign-up');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );

      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw Exception(responseData['error']);
      }

      return responseData;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> logIn(String email, String password) async {
    final url = Uri.parse(
        'https://tcayebnb36.execute-api.eu-west-1.amazonaws.com/prod/user/log-in');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw Exception(responseData['error']);
      }

      final token = responseData['message']['token'];

      final payload = parseJwtPayLoad(token);

      _token = token;
      _email = email;
      _userId = payload['cognito:username'];
      _expiryDate = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);

      _autoLogout();
      _notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'email': _email,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );

      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) return false;

    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = extractedUserData['token'];
    _email = extractedUserData['email'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    _notifyListeners();
    _autoLogout();

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
    prefs.remove('userData');
  }

  void _autoLogout() {
    _authTimer?.cancel();

    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  void _notifyListeners() {
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
