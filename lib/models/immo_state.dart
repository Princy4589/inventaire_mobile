// To parse this JSON data, do
//
//     final immoState = immoStateFromJson(jsonString);

import 'dart:convert';

List<ImmoState> immoStateFromJson(String str) =>
    List<ImmoState>.from(json.decode(str).map((x) => ImmoState.fromJson(x)));

String immoStateToJson(List<ImmoState> data) =>
    json.encode(List<ImmoState>.from(data.map((e) => e.toJson())));

class ImmoState {
  ImmoState({
    this.immoStateId,
    this.state,
    this.modifiedTime,
    this.codeImmoId,
  });

  dynamic immoStateId;
  dynamic state;
  dynamic modifiedTime;
  dynamic codeImmoId;

  factory ImmoState.fromJson(Map<String, dynamic> json) => ImmoState(
        immoStateId: json["immoStateId"],
        state: json["state"],
        modifiedTime: json["modifiedTime"],
        codeImmoId: json["code_immo_id"],
      );

  Map<String, dynamic> toJson() => {
        "immoStateId": immoStateId,
        "state": state,
        "modifiedTime": modifiedTime,
        "code_immo_id": codeImmoId,
      };

  Map<String, dynamic> toMap() => {
        "immoStateId": immoStateId,
        "state": state,
        "modifiedTime": modifiedTime,
        "code_immo_id": codeImmoId,
      };
}
