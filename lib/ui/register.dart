import 'package:alatareekeh/components/textfield.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sizer/sizer.dart';

class Register extends StatefulWidget {
  static const id = 'Register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();
  WebServices webServices = new WebServices();
  String dropDownMenu;
  bool _saving = false;
  String _usernameErrormsg;
  String _passwordErrormsg;
  String _phoneErrormsg;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: Scaffold(
        body: columnElements(),
      ),
      inAsyncCall: _saving,
    );
  } // end builder

  //-------------------------------Column --------------------------------------
  Widget columnElements() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            imageBackground(),
            registerContainer(),
          ],
        ),
      ),
    );
  }

//---------------------------Column Elements------------------------------------
  Widget imageBackground() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/ui/register/register.png'),
              fit: BoxFit.contain),
        ),
      ),
    );
  }

//--------------------------------Widgets---------------------------------------
  //-> Register User Button
  Widget Register() {
    return Container(
      padding: EdgeInsets.only(right: 55.0, left: 55.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Color(0xFF8949d8),
        child: Text(
          "register".tr().toString(),
          style: TextStyle(fontSize: 20.0.sp, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Colors.blueAccent,
          ),
        ),
        onPressed: () async {
          if (!_usernameController.text.isEmpty &&
              !_passwordController.text.isEmpty &&
              !_phoneController.text.isEmpty) {
            setState(() {
              _saving = true;
            });
            var message = await webServices.registerUser(
                _usernameController.text,
                _phoneController.text,
                dropDownMenu,
                _passwordController.text,
                _phoneController.text);

            setState(() {
              _saving = false;
            });
            print(message);
          } // end if
          // if (_usernameController.text.isEmpty) {
          //   setState(() {
          //     _usernameErrormsg = "please fill";
          //   });
          // }
          // if (_passwordController.text.isEmpty) {
          //   setState(() {
          //     _passwordErrormsg = "please fill";
          //   });
          // }
          // if (_phoneController.text.isEmpty) {
          //   setState(() {
          //     _phoneErrormsg = "please fill";
          //   });
          // }
        },
      ),
    );
  }
//--------------------------------------------------------------------------

  //-> Container for having elements
  Widget registerContainer() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Color(0xFFf2f2f2),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 2.0.h,
            ),
            Text(
              "register".tr().toString(),
              style: TextStyle(
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38),
            ),
            SizedBox(
              height: 4.0.h,
            ),
            TextInputField(
              hint_text: "username".tr().toString(),
              //label_text: "username",
              controller_text: _usernameController,
              show_password: false,
              error_msg: _usernameErrormsg,
            ),
            SizedBox(
              height: 5.0.h,
            ),
            TextInputField(
              hint_text: "password".tr().toString(),
              //label_text: "username",
              controller_text: _passwordController,
              show_password: false,
              error_msg: _passwordErrormsg,
            ),
            SizedBox(
              height: 5.0.h,
            ),
            TextInputField(
              hint_text: "phone".tr().toString(),
              //label_text: "username",
              controller_text: _genderController,
              show_password: false,
              error_msg: _phoneErrormsg,
            ),
            SizedBox(
              height: 5.0.h,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Text(
                    "gender".tr().toString(),
                    style: TextStyle(
                        fontSize: 20.0.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38),
                  ),
                ),
                SizedBox(
                  width: 20.0.w,
                ),
                new DropdownButton<String>(
                  value: "male".tr().toString(),
                  items: <String>[
                    'male'.tr().toString(),
                    'female'.tr().toString(),
                  ].map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value,
                        style: TextStyle(fontSize: 15.0.sp),
                      ),
                    );
                  }).toList(),
                  onChanged: (String value1) {
                    setState(() {
                      dropDownMenu = value1;
                    });
                  },
                )
              ],
            ),
            SizedBox(
              height: 2.0.h,
            ),
            Register(),
          ],
        ),
      ],
    );
  }

//------------------------------------------------------------------------------
} //end class
