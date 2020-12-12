import 'package:flutter/material.dart';

class LanguageSelect extends StatefulWidget {
  @override
  _LanguageSelectState createState() => _LanguageSelectState();
}

class _LanguageSelectState extends State<LanguageSelect> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: 25.0,
          width: 50.0,
          child: Text('Hello'),
        ),
      ),
    );
  } // end build

}

//TODO: Make Ui
