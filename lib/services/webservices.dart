import 'dart:convert';

import 'package:alatareekeh/constants/constants.dart';
import 'package:http/http.dart' as http;

class WebServices {
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
} // end class
