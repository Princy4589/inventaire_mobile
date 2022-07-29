// To parse this JSON data, do
//
//     final traceabilityService = traceabilityServiceFromJson(jsonString);

import 'dart:convert';

List<TraceabilityService> traceabilityServiceFromJson(String str) =>
    List<TraceabilityService>.from(
        json.decode(str).map((x) => TraceabilityService.fromJson(x)));

String traceabilityServiceToJson(List<TraceabilityService> data) =>
    json.encode(List<TraceabilityService>.from(data.map((e) => e.toJson())));

class TraceabilityService {
  TraceabilityService({
    this.traceabilityServiceId,
    this.userId,
    this.serviceId,
    this.startTime,
    this.endTime,
  });

  dynamic traceabilityServiceId;
  dynamic userId;
  dynamic serviceId;
  dynamic startTime;
  dynamic endTime;

  factory TraceabilityService.fromJson(Map<String, dynamic> json) =>
      TraceabilityService(
        traceabilityServiceId: json["traceability_service_id"],
        userId: json["user_id"],
        serviceId: json["service_id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
      );

  Map<String, dynamic> toJson() => {
        "traceability_service_id": traceabilityServiceId,
        "user_id": userId,
        "service_id": serviceId,
        "start_time": startTime,
        "end_time": endTime,
      };
  Map<String, dynamic> toMap() => {
        "traceability_service_id": traceabilityServiceId,
        "user_id": userId,
        "service_id": serviceId,
        "start_time": startTime,
        "end_time": endTime,
      };
}
