import 'dart:convert';

List<Log> logFromJson(String str) =>
    List<Log>.from(json.decode(str).map((x) => Log.fromJson(x)));

String logToJson(List<Log> data) =>
    json.encode(List<Log>.from(data.map((e) => e.toJson())));

class Log {
  Log({
    this.id,
    this.email,
    this.password,
    this.userId,
  });

  dynamic id;
  dynamic email;
  dynamic password;
  dynamic userId;

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "user_id": userId,
      };

  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "password": password,
        "user_id": userId,
      };
}
