// To parse this JSON data, do
//
//     final registerUserModel = registerUserModelFromJson(jsonString);

import 'dart:convert';

RegisterUserModel registerUserModelFromJson(String str) =>
    RegisterUserModel.fromJson(json.decode(str));

String registerUserModelToJson(RegisterUserModel data) => json.encode(data.toJson());

class RegisterUserModel {
  RegisterUserModel({
    this.message,
    this.userId,
  });

  String message;
  String userId;

  factory RegisterUserModel.fromJson(Map<String, dynamic> json) => RegisterUserModel(
        message: json["message"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "user_id": userId,
      };
}
