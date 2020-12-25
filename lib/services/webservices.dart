import 'dart:convert';

import 'package:alatareekeh/constants/constants.dart';
import 'package:http/http.dart' as http;

import 'getprovdiedservices.dart';

class WebServices {
  //------------------------------Register------------------------------
  Future<String> registerUser(
      String username, String phone, String gender, String password) async {
    http.Response response =
        await http.post(Constants.api_link + 'Register', body: {
      "username": username,
      "phone": phone,
      "gender": gender,
      "password": password,
      "photo": "photo"
    });

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data); // decoding data
      var message = decodedData['message'];

      return message;
    }
  }

  //----------------------------------Login-------------------------------------
  //-> Login and post data to server
  Future<String> LoginPost(String username, String password) async {
    http.Response response = await http.post(Constants.api_link + 'Login',
        body: {"username": username, "password": password});
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data); // decoding data
      var id = decodedData['customer_id'];
      var message = decodedData['message'];
      return message; // to return message from server
    }
  }
  //------------------------------Add Seek Service------------------------------

  Future<String> addSeekService(
      String userId,
      int status,
      int type,
      String phone,
      String space,
      String date,
      String gender,
      String from,
      String to,
      String username) async {
    http.Response response =
        await http.post(Constants.api_link + 'AddOrSeek_Service', body: {
      "user_id": userId,
      "status": status.toString(),
      "type": type.toString(),
      "phone": phone,
      "space": space,
      "date": date,
      "gender": gender,
      "from": from,
      "to": to,
      "username": username
    });

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data); // decoding data
      var message = decodedData['message'];
      return message;
    }
  }

//--------------------------Get Provided Services-------------------------------
  //-> this Api will return Provided Services
  static Future<List<GetProvidedServices>> Get_Provided_Services() async {
    try {
      final response = await http.get(
        Constants.api_link + 'Get_Provided_services?type=1',
      ); // one is the type
      // print(response);
      if (response.statusCode == 200) {
        final List<GetProvidedServices> getProvidedServices =
            getProvidedServicesFromJson(response.body);
        // print(getProvidedServices);
        return getProvidedServices;
      }
    } catch (e) {
      return List<GetProvidedServices>();
    }
  }
//------------------------------------------------------------------------------
} // end class
