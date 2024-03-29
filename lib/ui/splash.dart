import 'dart:async';

import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/ui/signin.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static String id = 'splash_screen'; // a global static for calling from any activity

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPref sharedPref = SharedPref(); // create object of the class
  String idSaved;
  //-> get the
  Future getLoginData() async {}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadTimer();
//    getLoginData();
  }

  //-> download
  //-> timer for launching screen after seconds
  Future<Timer> LoadTimer() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  Future onDoneLoading() async {
    Navigator.pushNamed(context, SignIn.id);
    // Navigator.pushNamed(context, Search.id);
    // String userId;
    // String selected_lang;
    // String privacypolicy;
    //
    // userId = await sharedPref.LoadData('userID');
    // selected_lang = await sharedPref.LoadData('selectedlanguage');
    // privacypolicy = await sharedPref.LoadData('privacypolicystate');
    //
    // if ((selected_lang == 'en' || selected_lang == 'ar') &&
    //     (privacypolicy == 'privacypolicyaccepted' && userId != null)) {
    //   Navigator.pushNamed(context, Navigation.id);
    // } else if ((selected_lang == 'en' || selected_lang == 'ar') &&
    //     (privacypolicy == 'privacypolicyaccepted' && userId == null)) {
    //   Navigator.pushNamed(context, SignIn.id);
    // } else if ((selected_lang == 'en' || selected_lang == 'ar') &&
    //     (privacypolicy == null && userId == null)) {
    //   Navigator.pushNamed(context, PrivacyPolicy.id);
    // } else {
    //   Navigator.pushNamed(context, LanguageSelect.id);
    // }
  } // end if

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: columnElements(),
      ),
    );
  }

  //-----------------------------Widget Tree------------------------------------
  Widget columnElements() {
    return Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 1,
            decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(35.0),
              image: DecorationImage(
                  image: AssetImage('assets/ui/splashscreen/background.png'), fit: BoxFit.fill),
            ),
          ),
        ),
      ],
    );
  }

  //--------------------------Logo background-----------------------------------
  Widget imageBackground(String asset_image) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(35.0),
          image: DecorationImage(image: AssetImage(asset_image), fit: BoxFit.fill),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

//------------------------------------------------------------------------------
}
//Todo: when user sign in call api call and check the user id if the user id matches the
//the id in the shared preferences go to home page
