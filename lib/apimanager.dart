// import 'dart:async';
// import 'package:http/http.dart'as http;
// import 'dart:io';
// import 'dart:convert';
// import 'dart:async';
// import 'package:connectivity/connectivity.dart';
//
// class ApiManager {
//   Future<dynamic> postApiCall(String url, Map param) async {
//     print("calling api:$url");
//     print("Calling params:$param");
//
//     var responseJson;
//   try{
//     final response=await http.post(Uri.parse(url),body: param);
//     responseJson=_response(response);
//
//   } on SocketException{
//     throw FetchD
//   }
//   catch()
//     {
//
//     }
//
//   }
// }
///ref: https://stackoverflow.com/questions/60648984/handling-exception-http-request-flutter
