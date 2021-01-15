// To parse this JSON data, do
//
//     final getSearchResults = getSearchResultsFromJson(jsonString);

import 'dart:convert';

List<GetSearchResults> getSearchResultsFromJson(String str) =>
    List<GetSearchResults>.from(
        json.decode(str).map((x) => GetSearchResults.fromJson(x)));

String getSearchResultsToJson(List<GetSearchResults> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSearchResults {
  GetSearchResults({
    this.userId,
    this.serviceId,
    this.serviceStatus,
    this.servicePickup,
    this.serviceDestination,
    this.serviceGender,
    this.userName,
    this.userPhone,
    this.serviceDate,
    this.serviceSpace,
    this.serviceType,
  });

  String userId;
  int serviceId;
  int serviceStatus;
  String servicePickup;
  String serviceDestination;
  String serviceGender;
  String userName;
  String userPhone;
  String serviceDate;
  String serviceSpace;
  int serviceType;

  factory GetSearchResults.fromJson(Map<String, dynamic> json) =>
      GetSearchResults(
        userId: json["user_id"],
        serviceId: json["service_id"],
        serviceStatus: json["service_status"],
        servicePickup: json["service_pickup"],
        serviceDestination: json["service_destination"],
        serviceGender: json["service_gender"],
        userName: json["user_name"],
        userPhone: json["user_phone"],
        serviceDate: json["service_date"],
        serviceSpace: json["service_space"],
        serviceType: json["service_type"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "service_id": serviceId,
        "service_status": serviceStatus,
        "service_pickup": servicePickup,
        "service_destination": serviceDestination,
        "service_gender": serviceGender,
        "user_name": userName,
        "user_phone": userPhone,
        "service_date": serviceDate,
        "service_space": serviceSpace,
        "service_type": serviceType,
      };
}
