// To parse this JSON data, do
//
//     final service = serviceFromJson(jsonString);

import 'dart:convert';

List<Service> serviceFromJson(String str) =>
    List<Service>.from(json.decode(str).map((x) => Service.fromJson(x)));

String serviceToJson(List<Service> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Service {
  Service({
    this.serviceId,
    this.directionId,
    this.name,
    this.code,
    this.description,
  });

  dynamic serviceId;
  dynamic directionId;
  dynamic name;
  dynamic code;
  dynamic description;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        serviceId: json["service_id"],
        directionId: json["direction_id"],
        name: json["name"],
        code: json["code"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "service_id": serviceId,
        "direction_id": directionId,
        "name": name,
        "code": code,
        "description": description,
      };

  Map<String, dynamic> toMap() => {
        "service_id": serviceId,
        "direction_id": directionId,
        "name": name,
        "code": code,
        "description": description,
      };
}
