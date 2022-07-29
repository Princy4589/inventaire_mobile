import 'dart:convert';

List<Sex> sexFromJson(String str) =>
    List<Sex>.from(json.decode(str).map((x) => Sex.fromJson(x)));

String sexToJson(List<Sex> data) =>
    json.encode(List<Sex>.from(data.map((x) => x.toJson())));

class Sex {
  Sex({
    this.sexId,
    this.name,
  });

  dynamic sexId;
  dynamic name;

  factory Sex.fromJson(Map<String, dynamic> json) => Sex(
        sexId: json["sex_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "sex_id": sexId,
        "name": name,
      };

  Map<String, dynamic> toMap() => {
        "sex_id": sexId,
        "name": name,
      };
}
