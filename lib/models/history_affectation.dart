// To parse this JSON data, do
//
//     final historyaffectation = historyaffectationFromJson(jsonString);

import 'dart:convert';

List<Historyaffectation> fistoryaffectationFromJson(String str) =>
    List<Historyaffectation>.from(
        json.decode(str).map((x) => Historyaffectation.fromJson(x)));

String historyaffectationToJson(List<Historyaffectation> data) =>
    json.encode(List<Historyaffectation>.from(data.map((e) => e.toJson())));

class Historyaffectation {
  Historyaffectation({
    this.historyId,
    this.timeOfOperation,
    this.codeImmoId,
    this.directionId,
    this.immoStateId,
    this.userId,
    this.personId,
    this.observation,
  });

  dynamic historyId;
  dynamic timeOfOperation;
  dynamic codeImmoId;
  dynamic directionId;
  dynamic immoStateId;
  dynamic userId;
  dynamic personId;
  dynamic observation;

  factory Historyaffectation.fromJson(Map<String, dynamic> json) =>
      Historyaffectation(
        historyId: json["history_id"],
        timeOfOperation: DateTime.parse(json["time_of_operation"]),
        codeImmoId: json["code_immo_id"],
        directionId: json["direction_id"],
        immoStateId: json["immoStateId"],
        userId: json["user_id"],
        personId: json["person_id"],
        observation: json["observation"],
      );

  Map<String, dynamic> toJson() => {
        "history_id": historyId,
        "time_of_operation": timeOfOperation.toIso8601String(),
        "code_immo_id": codeImmoId,
        "direction_id": directionId,
        "immoStateId": immoStateId,
        "user_id": userId,
        "person_id": personId,
        "observation": observation,
      };

  Map<String, dynamic> toMap() => {
        "history_id": historyId,
        "time_of_operation": timeOfOperation.toIso8601String(),
        "code_immo_id": codeImmoId,
        "direction_id": directionId,
        "immoStateId": immoStateId,
        "user_id": userId,
        "person_id": personId,
        "observation": observation,
      };
}
