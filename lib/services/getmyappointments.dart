// To parse this JSON data, do
//
//     final getMyAppointments = getMyAppointmentsFromJson(jsonString);

import 'dart:convert';

List<GetMyAppointments> getMyAppointmentsFromJson(String str) =>
    List<GetMyAppointments>.from(
        json.decode(str).map((x) => GetMyAppointments.fromJson(x)));

String getMyAppointmentsToJson(List<GetMyAppointments> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetMyAppointments {
  GetMyAppointments({
    this.customerId,
    this.providerId,
    this.appointmentId,
    this.customerName,
    this.customerPhone,
    this.customerGender,
    this.providerName,
    this.providerPhone,
    this.providerGender,
    this.pickupLocation,
    this.destination,
    this.date,
    this.space,
    this.latitude,
    this.longitude,
  });

  int customerId;
  int providerId;
  int appointmentId;
  String customerName;
  String customerPhone;
  String customerGender;
  String providerName;
  String providerPhone;
  String providerGender;
  String pickupLocation;
  String destination;
  String date;
  String space;
  double latitude;
  double longitude;

  factory GetMyAppointments.fromJson(Map<String, dynamic> json) =>
      GetMyAppointments(
        customerId: json["customer_id"],
        providerId: json["provider_id"],
        appointmentId: json["appointment_id"],
        customerName: json["customer_name"],
        customerPhone: json["customer_phone"],
        customerGender: json["customer_gender"],
        providerName: json["provider_name"],
        providerPhone: json["provider_phone"],
        providerGender: json["provider_gender"],
        pickupLocation: json["pickup_location"],
        destination: json["destination"],
        date: json["date"],
        space: json["space"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "customer_id": customerId,
        "provider_id": providerId,
        "appointment_id": appointmentId,
        "customer_name": customerName,
        "customer_phone": customerPhone,
        "customer_gender": customerGender,
        "provider_name": providerName,
        "provider_phone": providerPhone,
        "provider_gender": providerGender,
        "pickup_location": pickupLocation,
        "destination": destination,
        "date": date,
        "space": space,
        "latitude": latitude,
        "longitude": longitude,
      };
}
