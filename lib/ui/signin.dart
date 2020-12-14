import 'package:alatareekeh/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SignIn extends StatefulWidget {
  static const id = 'sign_in';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return columnElements();
  } // end builder

//---------------------------------Widget Tree----------------------------------
  Widget columnElements() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 5.0.h,
          ),
          imageBackground(),
          TextInputField(
            hint_text: "Hello",
            error_msg: "error",
          ),
        ],
      ),
    );
  }

//------------------------------------------------------------------------------
  //-> Widget of background
  Widget imageBackground() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/ui/login/login.jpg'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
//------------------------------------------------------------------------------
} // end class
