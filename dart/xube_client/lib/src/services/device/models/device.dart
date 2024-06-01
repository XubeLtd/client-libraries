import 'package:xube_client/src/models/base_model.dart';

const String nameField = "name";
const String makeField = "make";
const String modelField = "model";
const String generationField = "generation";
const String createdField = "created";

class Device extends BaseModel {
  String name;
  String make;
  String model;
  String generation;
  String created;

  Device({
    required super.version,
    required super.id,
    required this.name,
    required this.make,
    required this.model,
    required this.generation,
    required this.created,
  });

  static Device fromJson(Map<String, dynamic> json) {
    BaseModel? baseModel = BaseModel.fromJson(json);

    String name = json[nameField];
    String make = json[makeField];
    String model = json[modelField];
    String generation = json[generationField];
    String created = json[createdField];

    return Device(
      name: name,
      make: make,
      model: model,
      generation: generation,
      created: created,
      id: baseModel.id,
      version: baseModel.version,
    );
  }
}
