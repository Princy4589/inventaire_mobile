// To parse this JSON data, do
//
//     final affectedto = affectedtoFromJson(jsonString);

import 'dart:convert';

List<Affectedto> affectedtoFromJson(String str) =>
    List<Affectedto>.from(json.decode(str).map((x) => Affectedto.fromJson(x)));

String affectedtoToJson(List<Affectedto> data) =>
    json.encode(List<Affectedto>.from(data.map((e) => e.toJson())));

class Affectedto {
  Affectedto({
    this.affectedToId,
    this.addedTime,
    this.codeImmoId,
    this.userId,
  });

  dynamic affectedToId;
  dynamic addedTime;
  dynamic codeImmoId;
  dynamic userId;

  factory Affectedto.fromJson(Map<String, dynamic> json) => Affectedto(
        affectedToId: json["affectedTo_id"],
        addedTime: json["added_time"],
        codeImmoId: json["code_immo_id"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "affectedTo_id": affectedToId,
        "added_time": addedTime,
        "code_immo_id": codeImmoId,
        "user_id": userId,
      };

  Map<String, dynamic> toMap() => {
        "affectedTo_id": affectedToId,
        "added_time": addedTime,
        "code_immo_id": codeImmoId,
        "user_id": userId,
      };
}
