library xube_client;

import 'package:xube_client/src/account.dart';
import 'package:xube_client/src/component.dart';
import 'package:xube_client/src/device.dart';
import 'package:xube_client/xube_client.dart';

class XubeClient {
  final XubeClientAuth _auth;
  final XubeClientAccount _account;
  final XubeClientComponent _component;
  final XubeClientDevice _device;

  XubeClientAuth get auth => _auth;
  XubeClientAccount get account => _account;
  XubeClientComponent get component => _component;
  XubeClientDevice get device => _device;

  XubeClient({
    XubeClientAuth? auth,
    XubeClientAccount? account,
    XubeClientComponent? component,
    XubeClientDevice? device,
  })  : _auth = auth ?? XubeClientAuth(),
        _account = account ?? XubeClientAccount(),
        _component = component ?? XubeClientComponent(),
        _device = device ?? XubeClientDevice();
}
