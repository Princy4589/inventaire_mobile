// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    this.userId,
    this.email,
    this.hash,
    this.createTime,
    this.personId,
    this.isActive,
    this.registrationNumber,
    this.nameImage,
    this.nif,
    this.stat,
    this.officeNumber,
    this.phoneNumber,
    this.emergencyPhone,
  });

  dynamic userId;
  dynamic email;
  dynamic hash;
  dynamic createTime;
  dynamic personId;
  dynamic isActive;
  dynamic registrationNumber;
  dynamic nameImage;
  dynamic nif;
  dynamic stat;
  dynamic officeNumber;
  dynamic phoneNumber;
  dynamic emergencyPhone;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        email: json["email"],
        hash: json["hash"],
        createTime: DateTime.parse(json["create_time"]),
        personId: json["person_id"],
        isActive: json["is_active"],
        registrationNumber: json["registration_number"],
        nameImage: json["name_image"],
        nif: json["nif"],
        stat: json["stat"],
        officeNumber: json["office_number"],
        phoneNumber: json["phone_number"],
        emergencyPhone: json["emergency_phone"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "email": email,
        "hash": hash,
        "create_time": createTime!.toIso8601String(),
        "person_id": personId,
        "is_active": isActive,
        "registration_number": registrationNumber,
        "name_image": nameImage,
        "nif": nif,
        "stat": stat,
        "office_number": officeNumber,
        "phone_number": phoneNumber,
        "emergency_phone": emergencyPhone,
      };

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "email": email,
        "hash": hash,
        "create_time": createTime!.toIso8601String(),
        "person_id": personId,
        "is_active": isActive,
        "registration_number": registrationNumber,
        "name_image": nameImage,
        "nif": nif,
        "stat": stat,
        "office_number": officeNumber,
        "phone_number": phoneNumber,
        "emergency_phone": emergencyPhone,
      };
}
