import 'dart:convert';
import 'dart:io';

import 'package:alatareekeh/components/textfield.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/snackbar.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/signin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sizer/sizer.dart';

class Register extends StatefulWidget {
  static const id = 'Register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  WebServices webServices = new WebServices();
  snackbarMessage _snackMessage = snackbarMessage();
  SharedPref sharedPref = SharedPref();
  String dropDownMenu =
      "male"; // very important or we will get a null message when fetching api services
  bool _saving = false;

  bool _validateUsername = false;
  bool _validatePassword = false;
  bool _validatePhone = false;

  //-> for image picker
  final ImagePicker _picker = new ImagePicker();
  File imageFile;
  String imageFilePath;
  String image64;

  //------------------------Get the image from the gallery-------------------
  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      //-> if the user didn't select any image
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        imageFilePath = pickedFile.path;
      } else {
        // display message for selecting image
      }
    });
    // encode image to base64 for saving it as string
    final bytes = await imageFile.readAsBytes();
    image64 = base64Encode(bytes);
    print(image64);

    //String base64Encode(List<int> bytes) => base64.encode(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false, // to disable scolling screen up when keyboard goes up
          key: _scaffoldKey,
          body: columnElements(),
        ),
      ),
      inAsyncCall: _saving,
    );
  } // end builder

  //-------------------------------Column --------------------------------------
  Widget columnElements() {
    return Stack(
      alignment: Alignment.center,
      fit: StackFit.expand,
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(top: 0, child: imageBackground()),
        Positioned(top: 180, child: profileImage()),
        Positioned(bottom: 100, child: registerContainer()),
      ],
    );
  }

//---------------------------Column Elements------------------------------------
  Widget imageBackground() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/ui/register/register.png'), fit: BoxFit.fill),
        ),
      ),
    );
  }

//------------------------------Profile Image-----------------------------------
  Widget profileImage() {
    return InkWell(
      onTap: () async {
        getImage();
        //TODO: use image picker to select the image to save it to the database
      },
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.25)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: imageFile != null
                //-> clipoval to make the image in
                ? ClipOval(
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipOval(child: Icon(Icons.image)),
          ),
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
        color: Color(0xFFFFB005),
        child: Text(
          "register".tr().toString(),
          style: TextStyle(fontSize: 20.0.sp, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Color(0xFFFFD359),
          ),
        ),
        onPressed: () async {
          //- To check the user already entered username and password
          setState(() {
            _usernameController.text.isEmpty ? _validateUsername = true : _validateUsername = false;

            _passwordController.text.isEmpty ? _validatePassword = true : _validatePassword = false;

            _phoneController.text.isEmpty ? _validatePhone = true : _validatePhone = false;
          });

          //  if user didn't enter username or password or phone keep inside
          if (_validateUsername || _validatePassword || _validatePhone) {
            return;
          }
          // -> show progress bar if user already entered the required data
          setState(() {
            _saving = true;
          });
          // parse data to server
          var message = await webServices.registerUser(_usernameController.text,
              _phoneController.text, dropDownMenu, _passwordController.text, image64);

          print(message);

          // data finished
          setState(() {
            _saving = false;
          });

          //TODO: Test is register success go to login page and load the register data to login screen
          if (message.toString().contains('login succussfully')) {
            //-> if we have a success register go to the login page and save data to shared pref
            sharedPref.setData('username', _usernameController.text); // save user name of user
            sharedPref.setData('password', _passwordController.text); // save password of user
            sharedPref.setData('gender', dropDownMenu); //save gender  of user

            sharedPref.setData('phone', _phoneController.text); // save phone of gender

            //-> send params to login screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => SignIn(
                  phone_registerpage: _phoneController.text,
                  password_registerpage: _passwordController.text,
                ),
              ),
            );
          } //end iff

          //-> Display snackbar message
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(message),
            duration: Duration(seconds: 3),
          ));

          //-> save
        },
      ),
    );
  }

//--------------------------------------------------------------------------

  //-> Container for having elements
  Widget registerContainer() {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 1.0.h,
            ),
            Text(
              "register".tr().toString(),
              style:
                  TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.bold, color: Colors.black38),
            ),
            SizedBox(
              height: 1.0.h,
            ),
            TextInputField(
              hint_text: "username".tr().toString(),
              controller_text: _usernameController,
              show_password: false,
              error_msg: _validateUsername ? "valuecannotbeempty".tr().toString() : null,
            ),
            SizedBox(
              height: 1.0.h,
            ),
            TextInputField(
              hint_text: "password".tr().toString(),
              controller_text: _passwordController,
              show_password: true, // hide password for the user
              error_msg: _validatePassword ? "valuecannotbeempty".tr().toString() : null,
            ),
            SizedBox(
              height: 1.0.h,
            ),
            TextInputField(
              hint_text: "phone".tr().toString(),
              controller_text: _phoneController,
              show_password: false,
              error_msg: _validatePhone ? "valuecannotbeempty".tr().toString() : null,
            ),
            SizedBox(
              height: 1.0.h,
            ),
            Row(
              children: [
                Container(
                  //  padding: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: Text(
                    "gender".tr().toString(),
                    style: TextStyle(
                        fontSize: 20.0.sp, fontWeight: FontWeight.bold, color: Colors.black38),
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
//TODO:  when fail register show toast message
