import 'dart:convert';

List<Person> personFromJson(String str) =>
    List<Person>.from(json.decode(str).map((x) => Person.fromJson(x)));

String personToJson(List<Person> data) =>
    json.encode(List<Person>.from(data.map((e) => e.toJson())));

class Person {
  Person({
    this.personId,
    this.firstName,
    this.lastName,
    this.personnalEmail,
    this.cardNumber,
    this.cardDate,
    this.birthDate,
    this.telephone,
    this.sexId,
    this.cardDeliveranceDate,
    this.birthPlace,
    this.cardDeliverancePlace,
    this.numberChild,
    this.address,
    this.maritalStatus,
    this.cardDuplicateDate,
  });

  dynamic personId;
  dynamic firstName;
  dynamic lastName;
  dynamic personnalEmail;
  dynamic cardNumber;
  dynamic cardDate;
  dynamic birthDate;
  dynamic telephone;
  dynamic sexId;
  dynamic cardDeliveranceDate;
  dynamic birthPlace;
  dynamic cardDeliverancePlace;
  dynamic numberChild;
  dynamic address;
  dynamic maritalStatus;
  dynamic cardDuplicateDate;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        personId: json["person_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        personnalEmail: json["personnal_email"],
        cardNumber: json["card_number"],
        cardDate: json["card_date"],
        birthDate: json["birth_date"],
        telephone: json["telephone"],
        sexId: json["sex_id"],
        cardDeliveranceDate: json["card_deliverance_date"],
        birthPlace: json["birth_place"],
        cardDeliverancePlace: json["card_deliverance_place"],
        numberChild: json["number_child"],
        address: json["address"],
        maritalStatus: json["marital_status"],
        cardDuplicateDate: json["card_duplicate_date"],
      );

  Map<String, dynamic> toJson() => {
        "person_id": personId,
        "first_name": firstName,
        "last_name": lastName,
        "personnal_email": personnalEmail,
        "card_number": cardNumber,
        "card_date": cardDate,
        "birth_date":
            "${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
        "telephone": telephone,
        "sex_id": sexId,
        "card_deliverance_date":
            "${cardDeliveranceDate.year.toString().padLeft(4, '0')}-${cardDeliveranceDate.month.toString().padLeft(2, '0')}-${cardDeliveranceDate.day.toString().padLeft(2, '0')}",
        "birth_place": birthPlace,
        "card_deliverance_place": cardDeliverancePlace,
        "number_child": numberChild,
        "address": address,
        "marital_status": maritalStatus,
        "card_duplicate_date":
            "${cardDuplicateDate.year.toString().padLeft(4, '0')}-${cardDuplicateDate.month.toString().padLeft(2, '0')}-${cardDuplicateDate.day.toString().padLeft(2, '0')}",
      };

  Map<String, dynamic> toMap() => {
        "person_id": personId,
        "first_name": firstName,
        "last_name": lastName,
        "personnal_email": personnalEmail,
        "card_number": cardNumber,
        "card_date": cardDate,
        "birth_date": birthDate,
        "telephone": telephone,
        "sex_id": sexId,
        "card_deliverance_date": cardDeliveranceDate,
        "birth_place": birthPlace,
        "card_deliverance_place": cardDeliverancePlace,
        "number_child": numberChild,
        "address": address,
        "marital_status": maritalStatus,
        "card_duplicate_date": cardDuplicateDate
      };
}
