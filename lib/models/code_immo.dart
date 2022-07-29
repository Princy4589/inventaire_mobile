// To parse this JSON data, do
//
//     final codeImmo = codeImmoFromJson(jsonString);

import 'dart:convert';

List<CodeImmo> codeImmoFromJson(String str) =>
    List<CodeImmo>.from(json.decode(str).map((x) => CodeImmo.fromJson(x)));

String codeImmoToJson(List<CodeImmo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CodeImmo {
  CodeImmo({
    required this.codeImmoId,
    required this.codeImmoCode,
    required this.name,
    required this.codeName,
    required this.acquisValue,
    required this.dateAcquis,
    required this.funding,
    required this.direction,
    required this.numberOrdre,
    required this.isExtrat,
  });

  dynamic codeImmoId;
  dynamic codeImmoCode;
  dynamic name;
  dynamic codeName;
  dynamic acquisValue;
  dynamic dateAcquis;
  dynamic funding;
  dynamic direction;
  dynamic numberOrdre;
  dynamic isExtrat;

  factory CodeImmo.fromJson(Map<String, dynamic> json) => CodeImmo(
        codeImmoId: json["code_immo_id"],
        codeImmoCode: json["code_immo_code"],
        name: json["name"],
        codeName: json["code_name"],
        acquisValue: json["acquis_value"],
        dateAcquis: json["date_acquis"],
        funding: json["funding"],
        direction: json["direction"],
        numberOrdre: json["number_ordre"],
        isExtrat: json["isExtrat"],
      );

  Map<String, dynamic> toJson() => {
        "code_immo_id": codeImmoId,
        "code_immo_code": codeImmoCode,
        "name": name,
        "code_name": codeName,
        "acquis_value": acquisValue,
        "date_acquis": dateAcquis,
        "funding": funding,
        "direction": direction,
        "number_ordre": numberOrdre,
        "isExtrat": isExtrat,
      };

  Map<String, dynamic> toMap() {
    return {
      "code_immo_id": codeImmoId,
      "code_immo_code": codeImmoCode,
      "name": name,
      "code_name": codeName,
      "acquis_value": acquisValue,
      "date_acquis": dateAcquis,
      "funding": funding,
      "direction": direction,
      "number_ordre": numberOrdre,
      "isExtrat": isExtrat,
    };
  }
}
