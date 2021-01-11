// To parse this JSON data, do
//
//     final getUserInfo = getUserInfoFromJson(jsonString);

import 'dart:convert';

GetUserInfo getUserInfoFromJson(String str) =>
    GetUserInfo.fromJson(json.decode(str));

String getUserInfoToJson(GetUserInfo data) => json.encode(data.toJson());

class GetUserInfo {
  GetUserInfo({
    this.username,
    this.usergender,
    this.userphoto,
    this.usephone,
  });

  String username;
  String usergender;
  String userphoto;
  String usephone;

  factory GetUserInfo.fromJson(Map<String, dynamic> json) => GetUserInfo(
        username: json["username"],
        usergender: json["usergender"],
        userphoto: json["userphoto"],
        usephone: json["usephone"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "usergender": usergender,
        "userphoto": userphoto,
        "usephone": usephone,
      };
}
