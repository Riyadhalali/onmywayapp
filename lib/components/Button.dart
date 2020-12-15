import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Button extends StatelessWidget {
  final Color colour;
  final String text;
  final String username_input;
  final Function onPressed;

  Button({this.colour, this.text, this.username_input, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 5.0.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: const Color(0xff2d2e39),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text.tr().toString(),
          style: TextStyle(color: colour, fontSize: 22.0.sp),
        ),
        style: ButtonStyle(),
      ),
    );
  }
}
