// To parse this JSON data, do
//
//     final direction = directionFromJson(jsonString);

import 'dart:convert';

List<Direction> directionFromJson(String str) =>
    List<Direction>.from(json.decode(str).map((x) => Direction.fromJson(x)));

String directionToJson(List<Direction> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Direction {
  Direction({
    this.directionId,
    this.type,
    this.description,
    this.directionParentId,
    this.code,
    this.name,
  });

  dynamic directionId;
  dynamic type;
  dynamic description;
  dynamic directionParentId;
  dynamic code;
  dynamic name;

  factory Direction.fromJson(Map<String, dynamic> json) => Direction(
        directionId: json["direction_id"],
        type: json["type"],
        description: json["description"],
        directionParentId: json["direction_parent_id"],
        code: json["code"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "direction_id": directionId,
        "type": type,
        "description": description,
        "direction_parent_id": directionParentId,
        "code": code,
        "name": name,
      };

  Map<String, dynamic> toMap() => {
        "direction_id": directionId,
        "type": type,
        "description": description,
        "direction_parent_id": directionParentId,
        "code": code,
        "name": name,
      };
}
