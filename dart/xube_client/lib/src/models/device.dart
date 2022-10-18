// {
//     "deviceID": "393edb10-5ae7-4976-850d-e808d887ae64",
//     "creator": "me@xube.io",
//     "v": "1",
//     "created": "2022-10-13T18:03:17.371Z",
//     "account": "Dave's merry band",
//     "SK": "DEVICE#393edb10-5ae7-4976-850d-e808d887ae64",
//     "PK": "ACCOUNT#Dave's merry band",
//     "id": "393edb10-5ae7-4976-850d-e808d887ae64",
//     "name": "393edb10-5ae7-4976-850d-e808d887ae64"
// },

class Device {
  final String deviceID;
  final String creator;
  final String v;
  final String created;
  final String account;
  final String sortKey;
  final String partitionKey;
  final String id;
  final String name;

  Device({
    required this.deviceID,
    required this.creator,
    required this.v,
    required this.created,
    required this.account,
    required this.sortKey,
    required this.partitionKey,
    required this.id,
    required this.name,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceID: json['deviceID'],
      creator: json['creator'],
      v: json['v'],
      created: json['created'],
      account: json['account'],
      sortKey: json['SK'],
      partitionKey: json['PK'],
      id: json['id'],
      name: json['name'],
    );
  }
}
