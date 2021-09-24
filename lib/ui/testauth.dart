// import 'package:flutter/material.dart';
// import 'package:visa/auth-data.dart';
// import 'package:visa/fb.dart';
//
// class AuthPage extends StatelessWidget {
//   static const id = 'AuthPage';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//         /// Simply Provide all the necessary credentials
//         body: FacebookAuth().visa.authenticate(
//               clientID: '139732240983759',
//               redirectUri: 'https://www.e-oj.com/oauth',
//               scope: 'public_profile,email',
//               state: 'fbAuth',
//               onDone: done,
//             ));
//   }
//
//   done(AuthData authData) {
//     print(authData);
//
//     /// You can pass the [AuthData] object to a
//     /// post-authentication screen. It contaions
//     /// all the user and OAuth data collected during
//     /// the authentication process. In this example,
//     /// our post-authentication screen is "complete-profile".
//   }
// }
