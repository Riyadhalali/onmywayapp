// To parse this JSON data, do
//
//     final getServiceLocation = getServiceLocationFromJson(jsonString);

import 'dart:convert';

GetServiceLocation getServiceLocationFromJson(String str) =>
    GetServiceLocation.fromJson(json.decode(str));

String getServiceLocationToJson(GetServiceLocation data) =>
    json.encode(data.toJson());

class GetServiceLocation {
  GetServiceLocation({
    this.lat,
    this.lon,
  });

  double lat;
  double lon;

  factory GetServiceLocation.fromJson(Map<String, dynamic> json) =>
      GetServiceLocation(
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lon": lon,
      };
}
