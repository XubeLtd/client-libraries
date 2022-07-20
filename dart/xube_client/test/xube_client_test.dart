import 'dart:convert';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
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

  test('Xube Client init', () {
    XubeClient();
  });

  test('Account subscription', () async {
    final channel = WebSocketChannel.connect(
      Uri.parse('wss://wpc1qzf6mk.execute-api.eu-west-1.amazonaws.com/dev'),
    );
    expect(channel, isNotNull);

    channel.stream.listen(
      expectAsync1(
        (event) {
          log('event: $event');
          expect(event, isNotNull);
        },
      ),
    );

    channel.sink.add(
      json.encode(
        {
          'action': 'Subscribe',
          'format': 'View',
          'contextType': 'ACCOUNT',
          'contextID': 'sub account 20',
          'subscriptionType': 'ACCOUNT',
          'subscriptionID': 'sub account 20',
        },
      ),
    );

    channel.sink.close();
    // expect(channel.closeCode, isNotNull);
  });
}
