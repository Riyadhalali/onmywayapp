// To parse this JSON data, do
//
//     final getAppVersion = getAppVersionFromJson(jsonString);

import 'dart:convert';

GetAppVersion getAppVersionFromJson(String str) =>
    GetAppVersion.fromJson(json.decode(str));

String getAppVersionToJson(GetAppVersion data) => json.encode(data.toJson());

class GetAppVersion {
  GetAppVersion({
    this.androidVer,
    this.link,
  });

  int androidVer;
  String link;

  factory GetAppVersion.fromJson(Map<String, dynamic> json) => GetAppVersion(
        androidVer: json["android_ver"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "android_ver": androidVer,
        "link": link,
      };
}
