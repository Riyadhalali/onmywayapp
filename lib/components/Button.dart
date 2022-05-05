import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Button extends StatelessWidget {
  final Color colour;
  final Color textColor;
  final String text;
  final String username_input;
  final Function onPressed;

  Button({this.colour, this.text, this.username_input, this.onPressed, this.textColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: colour,
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text.tr().toString(),
          style: TextStyle(color: textColor, fontSize: 22.0.sp),
        ),
        style: ButtonStyle(),
      ),
    );
  }
}
