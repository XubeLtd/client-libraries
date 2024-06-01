class Component {
  final String id;
  final String account;
  final String name;

  Component({
    required this.id,
    required this.account,
    required this.name,
  });

  factory Component.fromJson(Map<String, dynamic> json) {
    return Component(
      id: json['id'],
      account: json['account'],
      name: json['name'],
    );
  }
}
