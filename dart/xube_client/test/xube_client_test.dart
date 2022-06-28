import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xube_client/xube_client.dart';

void main() async {
  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
  });

  test('User can sign up using email and password', () async {
    final auth = XubeClientAuth();
    final result = await auth.signUp('test16@test.com', 'P@ssW0rd');

    expect(result, isNotNull);
  });
  test('User can log in using email and password', () async {
    final auth = XubeClientAuth();
    await auth.logIn('test5@test.com', 'P@ssW0rd');

    expect(auth.isAuth, true);
    expect(auth.token, isNotNull);
    expect(auth.userId, isNotNull);
  });
}
