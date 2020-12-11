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
    return Container();
  }
}
