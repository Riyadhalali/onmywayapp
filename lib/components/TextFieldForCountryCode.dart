import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class TextFieldForCountryCode extends StatelessWidget {
  final TextEditingController controller_text;
  final String hint_text;
  final String error_msg;
  final Icon icon_widget;
  final Icon prefixIcon;
  final bool show_password;
  Function FunctionToDo;

  TextFieldForCountryCode(
      {this.hint_text,
      this.controller_text,
      this.error_msg,
      this.icon_widget,
      this.prefixIcon,
      this.show_password,
      this.FunctionToDo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 55.0, right: 55.0),
      child: IntlPhoneField(
        textAlign: TextAlign.start,
        obscureText: show_password, // to show password or not
        controller: controller_text, // the variable that will contain input user data
        decoration: InputDecoration(
          filled: true, // to change the color of textinputfilled
          border: InputBorder.none,
          fillColor: Color(0xFFEFEFF3),
          hintText: hint_text,
          errorText: error_msg,
          prefixIcon: prefixIcon,
          suffixIcon: icon_widget, // passing icon
        ),
        initialCountryCode: 'UAE',
        onChanged: (phone) {
          // print(phone.completeNumber);
        },
      ),
    );
  }
} //end class
