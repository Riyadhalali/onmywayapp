// import 'dart:async';
// import 'dart:io';
//
// import 'package:http/http.dart' as http;
//
// class ApiManager {
//   Future<dynamic> postApiCall(String url, Map param) async {
//     print("calling api:$url");
//     print("Calling params:$param");
//
//     var responseJson;
//     try {
//       final response = await http.post(Uri.parse(url), body: param);
//       responseJson = _response(response);
//     } on SocketException {}
//   }
// }
//
// ///ref: https://stackoverflow.com/questions/60648984/handling-exception-http-request-flutter
