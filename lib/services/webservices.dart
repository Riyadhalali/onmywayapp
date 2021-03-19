import 'dart:convert';

import 'package:alatareekeh/constants/constants.dart';
import 'package:alatareekeh/services/GetAppVersion.dart';
import 'package:alatareekeh/services/GetSearchResults.dart';
import 'package:alatareekeh/services/GetServiceLocation.dart';
import 'package:alatareekeh/services/GetUserInfo.dart';
import 'package:alatareekeh/services/getlogindata.dart';
import 'package:alatareekeh/services/getmyappointments.dart';
import 'package:alatareekeh/services/getmyservices.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:http/http.dart' as http;

import 'getprovdiedservices.dart';
import 'getseekedservices.dart';

class WebServices {
  SharedPref sharedPref = SharedPref();

  //------------------------------Register------------------------------
  Future<String> registerUser(
      String username, String phone, String gender, String password) async {
    var url = Constants.api_link + 'Register';
    http.Response response = await http.post(Uri.parse(url), body: {
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
    } else {
      throw ('error in registing player');
    }
  }

  //----------------------------------Login-------------------------------------
  //-> Login and post data to server
  Future<GetLoginData> LoginPost(String phone, String password) async {
    var url = Constants.api_link + 'Login_Player';
    final http.Response response = await http
        .post(Uri.parse(url), body: {"phone": phone, "password": password});
    if (response.statusCode == 200) {
      final GetLoginData getlogindata = getLoginDataFromJson(response.body);
      //  print(getlogindata.message);
      return getlogindata;
    } else {
      throw ('error in getting login data player');
    }
  }
  //------------------------------Add Seek Service------------------------------

  Future<String> addSeekService(
      String userId,
      int type,
      String phone,
      String space,
      String date,
      String gender,
      String from,
      String to,
      String username) async {
    var url = Constants.api_link + 'AddOrSeek_Service';

    http.Response response = await http.post(Uri.parse(url), body: {
      "user_id": userId,
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
      var userID = decodedData['user_id'];

      return message;
    }
  }

//--------------------------Get Provided Services-------------------------------
  //-> this Api will return Provided Services type is 1
  static Future<List<GetProvidedServices>> Get_Provided_Services() async {
    var url = Constants.api_link + 'Get_Provided_services?type=1';
    try {
      final response = await http.get(
        Uri.parse(url),
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

//----------------------Get Seeked Services-------------------------------------
  //-> this Api will return Seeked Services type is 2
  static Future<List<GetSeekedServices>> Get_Seeked_Services() async {
    var url = Constants.api_link + 'Get_Provided_services?type=2';
    try {
      final response = await http.get(
        Uri.parse(url),
      ); // two is the type
      // print(response);
      if (response.statusCode == 200) {
        final List<GetSeekedServices> getSeekedServices =
            getSeekedServicesFromJson(response.body);
        // print(getProvidedServices);

        return getSeekedServices;
      }
    } catch (e) {
      return List<GetSeekedServices>();
    }
  }

//--------------------------Add Appointment-------------------------------------
  Future<String> addAppointment(
      String customer_id,
      String provider_id,
      String customer_name,
      String provider_name,
      String customer_phone,
      String provider_phone,
      String customer_gender,
      String provider_gender,
      String pickup_location,
      String destination,
      String date,
      String space,
      String latitude,
      String longitude,
      String service_id) async {
    var url = Constants.api_link + 'Add_appointemnt';
    try {
      http.Response response = await http.post(Uri.parse(url), body: {
        "customer_id": customer_id,
        "provider_id": provider_id,
        "customer_name": customer_name,
        "provider_name": provider_name,
        "customer_phone": customer_phone,
        "provider_phone": provider_phone,
        "customer_gender": customer_gender,
        "provider_gender": provider_gender,
        "pickup_location": pickup_location,
        "destination": destination,
        "date": date,
        "space": space,
        "latitude": latitude,
        "longitude": longitude,
        "service_id": service_id
      });

      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data); // decoding data
        var message = decodedData['message'];

        return message;
      }
    } catch (e) {}
  }

//----------------------Get My Appointments-------------------------------------
  //-> pass user id to the function
  static Future<List<GetMyAppointments>> Get_My_Appointments(
      String userId) async {
    var url = Constants.api_link + 'Get_My_Appointments?user_id=$userId';
    try {
      final response = await http.get(
        Uri.parse(url),
      ); // pass user id
      // print(response);
      if (response.statusCode == 200) {
        final List<GetMyAppointments> getAppointmentServices =
            getMyAppointmentsFromJson(response.body);

        return getAppointmentServices;
      }
    } catch (e) {
      return List<GetMyAppointments>();
    }
  }

//--------------------------Get My Services-------------------------------------
//-> pass user id and type to the function
  static Future<List<GetMyServices>> Get_My_Services(
      String userID, String type) async {
    var url =
        Constants.api_link + 'Get_My_services?user_id=$userID' + '&type=$type';
    try {
      print(userID);
      final response = await http
          .get(Uri.parse(url)); // pass user id and type if seeked or provided
      if (response.statusCode == 200) {
        final List<GetMyServices> getMyServices =
            getMyServicesFromJson(response.body);
        //  print(response.body);
        return getMyServices;
      }
    } catch (e) {
      return List<GetMyServices>();
    }
  }

//----------------------------Delete Appointment--------------------------------
  static Future<String> deleteAppointment(
      String appointment_id, String service_id) async {
    var url = Constants.api_link +
        'Delete_Appointment?appointment_id=$appointment_id' +
        '&service_id=$service_id';
    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data); // decoding data
        var message = decodedData['message'];

        return message;
      }
    } catch (e) {}
  }

  //-------------------------Get Service Location-------------------------------
//-> this ,ethod will get the service Location
  static Future<GetServiceLocation> Get_Service_Location(
      String appointment_id) async {
    var url = Constants.api_link +
        'Get_Service_location?appointment_id=$appointment_id';
    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String data = response.body;
        final GetServiceLocation getServiceLocation =
            getServiceLocationFromJson(response.body);
        return getServiceLocation;
      }
    } catch (e) {
      print("error in geting data from service location api ");
    }
  }

  //---------------------------Get Login Data-----------------------------------
  static Future<GetUserInfo> Get_User_Info(String userId) async {
    var url = Constants.api_link + 'Get_User_Info?user_id=$userId';
    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String data = response.body;
        final GetUserInfo getUserInfo = getUserInfoFromJson(response.body);

        return getUserInfo;
      }
    } catch (e) {
      print("error in geting data from userinfo service ");
    }
  }

  //--------------------------Delete Service------------------------------------
  static Future<String> Delete_Service(String serviceId) async {
    var url = Constants.api_link + 'Delete_Service?service_id=$serviceId';
    try {
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data); // decoding data
        var message = decodedData['message'];

        return message;
      }
    } catch (e) {
      print('Error in delete service ' + e);
    }
  }

//---------------------------Search Services------------------------------------
  static Future<List<GetSearchResults>> Search_Services(
      String type, String from, String to, String gender, String date) async {
    var url = Constants.api_link +
        'Search_services?type=$type' +
        '&from=$from' +
        '&to=$to' +
        '&gender=$gender' +
        '&date=$date';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<GetSearchResults> getSearchResults =
            getSearchResultsFromJson(response.body);
        print(response.body);
        return getSearchResults;
      }
    } catch (e) {
      return List<GetSearchResults>();
    }
  }

//--------------------------Check App Version----------------------------------
  static Future<GetAppVersion> Get_Version() async {
    var url = Constants.api_link + 'Get_Version';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final GetAppVersion getAppVersion = getAppVersionFromJson(
            response.body); // saving responnse into dart objects
        return getAppVersion;
      }
    } catch (e) {
      throw 'error in getting app versiom method webservice';
    }
  }
//------------------------------------------------------------------------------
} // end class
