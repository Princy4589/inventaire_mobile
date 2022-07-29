import 'dart:convert';

List<Seat> seatFromJson(String str) =>
    List<Seat>.from(json.decode(str).map((x) => Seat.fromJson(x)));

String seatToJson(List<Seat> data) =>
    json.encode(List<Seat>.from(data.map((x) => x.toJson())));

class Seat {
  Seat({
    this.seatId,
    this.seatName,
    this.directionId,
  });

  dynamic seatId;
  dynamic seatName;
  dynamic directionId;

  factory Seat.fromJson(Map<String, dynamic> json) => Seat(
        seatId: json["seat_id"],
        seatName: json["seat_name"],
        directionId: json["direction_id"],
      );

  Map<String, dynamic> toJson() => {
        "seat_id": seatId,
        "seat_name": seatName,
        "direction_id": directionId,
      };
  Map<String, dynamic> toMap() => {
        "seat_id": seatId,
        "seat_name": seatName,
        "direction_id": directionId,
      };
}
