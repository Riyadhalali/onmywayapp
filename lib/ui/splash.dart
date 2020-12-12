import 'dart:async';

import 'package:flutter/material.dart';

import 'languageselect.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadTimer();
  }

  //-> timer for launching screen after seconds
  Future<Timer> LoadTimer() async {
    return new Timer(Duration(seconds: 5), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LanguageSelect()));
  }

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
