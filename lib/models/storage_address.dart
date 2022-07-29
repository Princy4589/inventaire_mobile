import 'dart:convert';

List<StorageAddress> storageAddressFromJson(String str) =>
    List<StorageAddress>.from(
        json.decode(str).map((x) => StorageAddress.fromJson(x)));

String storageAddressToJson(List<StorageAddress> data) =>
    json.encode(List<StorageAddress>.from(data.map((x) => x.toJson())));

class StorageAddress {
  StorageAddress({
    this.storageId,
    this.storageAddress,
    this.seatId,
  });

  dynamic storageId;
  dynamic storageAddress;
  dynamic seatId;

  factory StorageAddress.fromJson(Map<String, dynamic> json) => StorageAddress(
        storageId: json["storage_id"],
        storageAddress: json["storage_address"],
        seatId: json["seat_id"],
      );

  Map<String, dynamic> toJson() => {
        "storage_id": storageId,
        "storage_address": storageAddress,
        "seat_id": seatId,
      };

  Map<String, dynamic> toMap() => {
        "storage_id": storageId,
        "storage_address": storageAddress,
        "seat_id": seatId,
      };
}
