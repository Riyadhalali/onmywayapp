import 'dart:convert';

List<GetMyServices> getMyServicesFromJson(String str) =>
    List<GetMyServices>.from(
        json.decode(str).map((x) => GetMyServices.fromJson(x)));

String getMyServicesToJson(List<GetMyServices> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetMyServices {
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

  GetMyServices(
      {this.userId,
      this.serviceId,
      this.serviceStatus,
      this.servicePickup,
      this.serviceDestination,
      this.serviceGender,
      this.userName,
      this.userPhone,
      this.serviceDate,
      this.serviceSpace,
      this.serviceType});

  GetMyServices.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    serviceId = json['service_id'];
    serviceStatus = json['service_status'];
    servicePickup = json['service_pickup'];
    serviceDestination = json['service_destination'];
    serviceGender = json['service_gender'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
    serviceDate = json['service_date'];
    serviceSpace = json['service_space'];
    serviceType = json['service_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['service_id'] = this.serviceId;
    data['service_status'] = this.serviceStatus;
    data['service_pickup'] = this.servicePickup;
    data['service_destination'] = this.serviceDestination;
    data['service_gender'] = this.serviceGender;
    data['user_name'] = this.userName;
    data['user_phone'] = this.userPhone;
    data['service_date'] = this.serviceDate;
    data['service_space'] = this.serviceSpace;
    data['service_type'] = this.serviceType;
    return data;
  }
}
