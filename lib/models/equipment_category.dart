// To parse this JSON data, do
//
//     final equipmentCategory = equipmentCategoryFromJson(jsonString);

import 'dart:convert';

List<EquipmentCategory> equipmentCategoryFromJson(String str) =>
    List<EquipmentCategory>.from(
        json.decode(str).map((x) => EquipmentCategory.fromJson(x)));

String equipmentCategoryToJson(List<EquipmentCategory> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EquipmentCategory {
  EquipmentCategory({
    required this.equipmentCategoryId,
    required this.accountCode,
    required this.nameCategory,
    this.descCategory,
  });

  int equipmentCategoryId;
  String accountCode;
  String nameCategory;
  String? descCategory;

  factory EquipmentCategory.fromJson(Map<String, dynamic> json) =>
      EquipmentCategory(
        equipmentCategoryId: json["equipment_category_id"],
        accountCode: json["account_code"],
        nameCategory: json["name_category"],
        descCategory: json["desc_category"],
      );

  Map<String, dynamic> toJson() => {
        "equipment_category_id": equipmentCategoryId,
        "account_code": accountCode,
        "name_category": nameCategory,
        "desc_category": descCategory ?? descCategory,
      };
}
