// To parse this JSON data, do
//
//     final usersAffected = usersAffectedFromJson(jsonString);
import 'dart:convert';

List<UsersAffected> usersAffectedFromJson(String str) =>
    List<UsersAffected>.from(
        json.decode(str).map((x) => UsersAffected.fromJson(x)));

String usersAffectedToJson(List<UsersAffected> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// To parse this JSON data, do
//
//     final usersAffected = usersAffectedFromJson(jsonString);

class UsersAffected {
  UsersAffected({
    this.personId,
    this.firstName,
    this.lastName,
    this.cin,
    this.dateCin,
    this.lieuCin,
    this.datepCin,
    this.ddn,
    this.adresse,
    this.userId,
    this.nameImage,
    this.matricule,
    this.personnalEmail,
    this.bureau,
    this.flotte,
    this.urgence,
    this.service,
    this.porte,
    this.seat,
    this.dir,
    this.type,
  });

  dynamic personId;
  dynamic firstName;
  dynamic lastName;
  dynamic cin;
  dynamic dateCin;
  dynamic lieuCin;
  dynamic datepCin;
  dynamic ddn;
  dynamic adresse;
  dynamic userId;
  dynamic nameImage;
  dynamic matricule;
  dynamic personnalEmail;
  dynamic bureau;
  dynamic flotte;
  dynamic urgence;
  dynamic service;
  dynamic porte;
  dynamic seat;
  dynamic dir;
  dynamic type;

  factory UsersAffected.fromJson(Map<String, dynamic> json) => UsersAffected(
        personId: json['person_id'],
        firstName: json["first_name"],
        lastName: json["last_name"],
        cin: json["cin"],
        dateCin: json["date_cin"],
        lieuCin: json["lieu_cin"],
        datepCin: json["datep_cin"],
        ddn: json["ddn"],
        adresse: json["adresse"],
        userId: json["user_id"],
        nameImage: json["name_image"],
        matricule: json["matricule"],
        personnalEmail: json["personnal_email"],
        bureau: json["bureau"],
        flotte: json["flotte"],
        urgence: json["urgence"],
        service: json["service"],
        porte: json["porte"],
        seat: json["seat"],
        dir: json["dir"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "person_id": personId,
        "first_name": firstName,
        "last_name": lastName,
        "cin": cin,
        "date_cin": dateCin,
        "lieu_cin": lieuCin,
        "datep_cin": datepCin,
        "ddn": ddn,
        "adresse": adresse,
        "user_id": userId,
        "name_image": nameImage,
        "matricule": matricule,
        "personnal_email": personnalEmail,
        "bureau": bureau,
        "flotte": flotte,
        "urgence": urgence,
        "service": service,
        "porte": porte,
        "seat": seat,
        "dir": dir,
        "type": type,
      };
  Map<String, dynamic> toMap() => {
        "person_id": personId,
        "first_name": firstName,
        "last_name": lastName,
        "cin": cin,
        "date_cin": dateCin,
        "lieu_cin": lieuCin,
        "datep_cin": datepCin,
        "ddn": ddn,
        "adresse": adresse,
        "user_id": userId,
        "name_image": nameImage,
        "matricule": matricule,
        "personnal_email": personnalEmail,
        "bureau": bureau,
        "flotte": flotte,
        "urgence": urgence,
        "service": service,
        "porte": porte,
        "seat": seat,
        "dir": dir,
        "type": type,
      };
}
