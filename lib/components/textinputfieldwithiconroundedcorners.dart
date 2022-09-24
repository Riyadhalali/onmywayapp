import 'package:flutter/material.dart';

class TextInputFieldWithIconRoundedCorners extends StatelessWidget {
  final TextEditingController controller_text;
  final String hint_text;
  final String error_msg;
  final Icon icon_widget;
  final Color prefixIconColor;
  final String prefixIcon;
  final bool show_password;
  final IconButton suffixIcon;
  Function FunctionToDo;

  TextInputFieldWithIconRoundedCorners(
      {this.hint_text,
      this.controller_text,
      this.error_msg,
      this.icon_widget,
      this.show_password,
      this.FunctionToDo,
      this.prefixIcon,
      this.prefixIconColor,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(left: 55.0, right: 55.0),
      child: TextField(
        //  autofocus: true,
        textAlign: TextAlign.start,
        obscureText: show_password, // to show password or not
        controller: controller_text, // the variable that will contain input user data
        decoration: InputDecoration(
          filled: true,
          //   prefixIconConstraints: BoxConstraints(minHeight: 25, minWidth: 25),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImageIcon(
              AssetImage(prefixIcon),
              color: prefixIconColor,
              size: 5.0,
            ),
          ),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(30)),
          fillColor: Color(0xFFEFEFF3),
          hintText: hint_text,
          errorText: error_msg,
          //   suffix: InkWell(onTap: FunctionToDo, child: icon_widget),
          //   helperText: "Please put your password",
        ),
      ),
    );
  }
} //end class
