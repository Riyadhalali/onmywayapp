import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller_text;
  final String hint_text;
  final String error_msg;
  final Icon icon_widget;

  TextInputField(
      {this.hint_text, this.controller_text, this.error_msg, this.icon_widget});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 36.0,
      padding: EdgeInsets.only(left: 55.0, right: 55.0),
      child: TextField(
        textAlign: TextAlign.center,

        controller:
            controller_text, // the variable that will contain input user data
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFCCCAD2),
          hintText: hint_text.tr().toString(),
          errorText: error_msg,

          // labelText: "signin_password".tr().toString(),
          suffixIcon: icon_widget, // passing icon
          //   helperText: "Please put your password",
        ),
      ),
    );
  }
} //end class
