const String versionField = "v";
const String idField = "id";
const String nameField = "name";
const String emailField = "email";
const String creatorField = "creator";
const String createdField = "created";

class BaseModel {
  final String version;
  final String id;

  BaseModel({
    required this.version,
    required this.id,
  });

  static BaseModel fromJson(Map<String, dynamic> json) {
    String version = json[versionField] ?? '1';
    String id = json[idField] ?? '';

    return BaseModel(
      version: version,
      id: id,
    );
  }
}
