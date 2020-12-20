import 'package:alatareekeh/components/imageBackground.dart';
import 'package:alatareekeh/components/textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ForgetPassword extends StatefulWidget {
  static const id = 'ForgetPassword';
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _forgetpasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: columnElements(),
    );
  } // end build widget

//---------------------------Main Column----------------------------------------
  Widget columnElements() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ImageBackground(
              assetImage: 'assets/ui/forgetpassword/forgetpassword.png',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            TextInputField(
              hint_text: "enteremailaddress".tr().toString(),
              controller_text: _forgetpasswordController,
              show_password: false,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            forgetPasswordButton(),
          ],
        ),
      ),
    );
  }

//--------------------------Column Elements-------------------------------------
  Widget forgetPasswordButton() {
    return Container(
      padding: EdgeInsets.only(right: 55.0, left: 55.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Color(0xFF8949d8),
        child: Text(
          "submit".tr().toString(),
          style: TextStyle(fontSize: 20.0.sp, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Colors.blueAccent,
          ),
        ),
        onPressed: () async {
          //  Navigator.pushNamed(context, HomePage.id);
          //TODO: add circle progress indicator for parsing request
        },
      ),
    );
  }

//------------------------------------------------------------------------------
} // end class
