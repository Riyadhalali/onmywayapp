import 'package:alatareekeh/constants/colors.dart';
import 'package:flutter/material.dart';

class TextButtonWithIcon extends StatelessWidget {
  ColorsApp colorsApp = new ColorsApp();

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        textStyle: TextStyle(color: Colors.white),
        backgroundColor: colorsApp.buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      onPressed: () => {},
      icon: Icon(
        Icons.send_rounded,
      ),
      label: Text(
        'Contact me',
      ),
    );
  }
}
