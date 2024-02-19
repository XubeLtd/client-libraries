import 'package:xube_client/src/utils/xube_log.dart';

const String subscriptionPathsField = 'subscriptionPaths';
const String connectionIdField = 'connectionId';
const String dataField = 'data';

class SubscriptionDelivery {
  final List<String> subscriptionPaths;
  final String connectionId;
  final dynamic data;
  final XubeLog log;

  SubscriptionDelivery(
      {required this.subscriptionPaths,
      required this.connectionId,
      required this.data,
      required this.log});

  static SubscriptionDelivery? fromJson(
    Map<String, dynamic> json, {
    XubeLog? log,
  }) {
    log ??= XubeLog.getInstance();

    List<String>? subscriptionPaths = json[subscriptionPathsField];
    String? connectionId = json[connectionIdField];
    dynamic data = json[dataField];

    if (subscriptionPaths == null ||
        subscriptionPaths.isEmpty ||
        connectionId == null ||
        data == null) {
      log.error('SubscriptionDelivery.fromJson: Invalid data');
      return null;
    }

    return SubscriptionDelivery(
      subscriptionPaths: subscriptionPaths,
      connectionId: connectionId,
      data: data,
      log: log,
    );
  }

  Map<String, dynamic> toJson() => {
        subscriptionPathsField: subscriptionPaths,
        connectionIdField: connectionId,
        dataField: data,
      };
}
