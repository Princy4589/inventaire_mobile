// To parse this JSON data, do
//
//     final historystock = historystockFromJson(jsonString);

import 'dart:convert';

List<Historystock> historystockFromJson(String str) => List<Historystock>.from(
    json.decode(str).map((x) => Historystock.fromJson(x)));

String historystockToJson(List<Historystock> data) =>
    json.encode(List<Historystock>.from(data.map((e) => e.toJson())));

class Historystock {
  Historystock({
    this.historyId,
    this.timeOfOperation,
    this.codeImmoId,
    this.directionId,
    this.immoStateId,
    this.userId,
    this.storageId,
    this.observation,
  });

  dynamic historyId;
  dynamic timeOfOperation;
  dynamic codeImmoId;
  dynamic directionId;
  dynamic immoStateId;
  dynamic userId;
  dynamic storageId;
  dynamic observation;

  factory Historystock.fromJson(Map<String, dynamic> json) => Historystock(
        historyId: json["history_id"],
        timeOfOperation: DateTime.parse(json["time_of_operation"]),
        codeImmoId: json["code_immo_id"],
        directionId: json["direction_id"],
        immoStateId: json["immoStateId"],
        userId: json["user_id"],
        storageId: json["storage_id"],
        observation: json["observation"],
      );

  Map<String, dynamic> toJson() => {
        "history_id": historyId,
        "time_of_operation": timeOfOperation.toIso8601String(),
        "code_immo_id": codeImmoId,
        "direction_id": directionId,
        "immoStateId": immoStateId,
        "user_id": userId,
        "storage_id": storageId,
        "observation": observation,
      };
  Map<String, dynamic> toMap() => {
        "history_id": historyId,
        "time_of_operation": timeOfOperation.toIso8601String(),
        "code_immo_id": codeImmoId,
        "direction_id": directionId,
        "immoStateId": immoStateId,
        "user_id": userId,
        "storage_id": storageId,
        "observation": observation,
      };
}
