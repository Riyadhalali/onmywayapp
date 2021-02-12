import 'dart:async';

import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/ui/languageselect.dart';
import 'package:alatareekeh/ui/navigationbar.dart';
import 'package:alatareekeh/ui/privacypolicy.dart';
import 'package:alatareekeh/ui/signin.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static String id =
      'splash_screen'; // a global static for calling from any activity

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SharedPref sharedPref = SharedPref(); // create object of the class

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadTimer();
  }

  //-> timer for launching screen after seconds
  Future<Timer> LoadTimer() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }

  Future onDoneLoading() async {
    String userId;
    String selected_lang;
    String privacypolicy;
    userId = await sharedPref.LoadData('userID');
    selected_lang = await sharedPref.LoadData('selectedlanguage');
    privacypolicy = await sharedPref.LoadData('privacypolicystate');
    // print('user id from splash screen' + userId.toString());
    // print('privacy policy is: ' + privacypolicy.toString());
    // print('language selected by user ' + selected_lang.toString());

    if ((selected_lang == 'en' || selected_lang == 'ar') &&
        (privacypolicy == 'privacypolicyaccepted' && userId != null)) {
      Navigator.pushNamed(context, Navigation.id);
    } else if ((selected_lang == 'en' || selected_lang == 'ar') &&
        (privacypolicy == 'privacypolicyaccepted' && userId == null)) {
      Navigator.pushNamed(context, SignIn.id);
    } else if ((selected_lang == 'en' || selected_lang == 'ar') &&
        (privacypolicy == null && userId == null)) {
      Navigator.pushNamed(context, PrivacyPolicy.id);
    } else {
      Navigator.pushNamed(context, LanguageSelect.id);
    }
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
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        imageBackground(),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        Container(
          padding: EdgeInsets.all(50.0),
          alignment: Alignment.bottomCenter,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
        ),
      ],
    );
  }

  //--------------------------Logo background-----------------------------------
  Widget imageBackground() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35.0),
          image: DecorationImage(
              image: AssetImage('assets/ui/splashscreen/appicon.png'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

//------------------------------------------------------------------------------
}
//done
