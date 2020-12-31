// To parse this JSON data, do
//
//     final getLoginData = getLoginDataFromJson(jsonString);

import 'dart:convert';

GetLoginData getLoginDataFromJson(String str) =>
    GetLoginData.fromJson(json.decode(str));

String getLoginDataToJson(GetLoginData data) => json.encode(data.toJson());

class GetLoginData {
  GetLoginData({
    this.id,
    this.message,
  });

  String id;
  String message;

  factory GetLoginData.fromJson(Map<String, dynamic> json) => GetLoginData(
        id: json["id"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
      };
}
