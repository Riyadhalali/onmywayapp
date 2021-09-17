import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController controller_text;
  final String hint_text;
  final String error_msg;
  final Icon icon_widget;
  final bool show_password;
  Function FunctionToDo;

  TextInputField(
      {this.hint_text,
      this.controller_text,
      this.error_msg,
      this.icon_widget,
      this.show_password,
      this.FunctionToDo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 55.0, right: 55.0),
      child: TextFormField(
        //  autofocus: true,
        textAlign: TextAlign.start,
        obscureText: show_password, // to show password or not
        controller: controller_text, // the variable that will contain input user data
        decoration: InputDecoration(
          filled: true, // to change the color of textinputfilled
          //   suffix: InkWell(onTap: FunctionToDo, child: icon_widget),
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
          border: InputBorder.none,
          fillColor: Color(0xFFEFEFF3),
          hintText: hint_text,
          errorText: error_msg,
          // labelText: label_text.tr().toString(),
          suffixIcon: icon_widget, // passing icon
          //suffix: InkWell(onTap: FunctionToDo, child: icon_widget),
          //   helperText: "Please put your password",
        ),
      ),
    );
  }
} //end class
