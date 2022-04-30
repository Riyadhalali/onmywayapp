import 'dart:ui';

import 'package:alatareekeh/components//textfield.dart';
import 'package:alatareekeh/components//textfieldwithicon.dart';
import 'package:alatareekeh/services/getlogindata.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/register.dart';
import 'package:alatareekeh/utils/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

import 'navigationbar.dart';

class SignIn extends StatefulWidget {
  static const id = 'sign_in';
  final String phone_registerpage;
  final String password_registerpage;

  SignIn({this.phone_registerpage, this.password_registerpage});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GetLoginData getLogin;
  String phone_data, password_data; //variables for holding shared pref data
  String usernameData; // this variable to store data returned from getUserInfo Api
  String userPhoneData; // this variable to store data returned from getUserInfo Api
  String userGenderData; // this variable to store data returned from getUserInfo Api
  String idSaved;
  final _phonecontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  WebServices webServices = new WebServices();
  SharedPref sharedPref = new SharedPref();
  Utils utils = Utils();

  bool validatePhone = false;
  bool validatePassword = false;
  bool _isHidden = false;

  // load user phone number and password from shared pref
  Future loadLoginData() async {
    phone_data = await sharedPref.LoadData('phone');
    password_data = await sharedPref.LoadData('password');
    idSaved = await sharedPref.LoadData("userID");
    print("getting id from local storage.. $idSaved");
    if (phone_data != null && password_data != null) {
      setState(() {
        _phonecontroller.text = phone_data;
        _passwordcontroller.text = password_data;
      });
    }
  }

  // get the phone and password from register page

  void getRegisterPage(String phone, String password) {
    _phonecontroller.text = phone;
    _passwordcontroller.text = password;
  }

  //-> Sign in Function
  //------------------------------SIgn in---------------------------------------
  Future SignInFunction() async {
    var message;
    var user_id;

    setState(() {
      _phonecontroller.text.isEmpty ? validatePhone = true : validatePhone = false;

      _passwordcontroller.text.isEmpty ? validatePassword = true : validatePassword = false;
    });
    //
    if (validatePhone || validatePassword) {
      return;
    }
    utils.showProcessingDialog("Loading ...", context);
    WebServices.LoginPost(_phonecontroller.text.toString(), _passwordcontroller.text.toString())
        .then((value) {
      //-> saving message and id from server
      user_id = value.id;
      print(user_id);
      message = value.message;
      Navigator.of(context).pop();
      // //-> save id to shared pref
      sharedPref.setData('userID', user_id); // save user id to shared pref
      sharedPref.setData('phone', _phonecontroller.text); // save the phone number of user
      sharedPref.setData('password', _passwordcontroller.text); //save the password of user
      if (message.toString().contains('login success')) {
        Navigator.pushNamed(context, Navigation.id); // if user exists go to main page
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.message)));
    }).catchError((error) {
      print(error);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    });

    // GetLoginData fmain =
    //     await webServices.LoginPost(_phonecontroller.text, _passwordcontroller.text);
    // message = fmain.message;
    // user_id = fmain.id;
    //
    // //-> get user info from server and then save it to shared pref and make sure that it already have an id
    // if (user_id != null) {
    //   final GetUserInfo getUserInfo = await WebServices.Get_User_Info(user_id);
    //   usernameData = getUserInfo.username;
    //   userGenderData = getUserInfo.usergender;
    // } else {
    //   return;
    // }

    //
    // // //-> save user profile to shared pref
    //sharedPref.setData('username', usernameData); // save the username
    //sharedPref.setData('gender', userGenderData); //save gender
    // Navigator.pushNamed(context, Navigation.id);
  }
  //----------------------------------------------------------------------------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLoginData(); // load user data saved
    getRegisterPage(widget.phone_registerpage,
        widget.password_registerpage); // pass the data from register page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: columnElements(),
    );
  } // end builder

//---------------------------------Widget Tree----------------------------------
  Widget columnElements() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            imageBackground(),
            sign_in_Container(),
          ],
        ),
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
        height: MediaQuery.of(context).size.height * 0.42,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/ui/login/login.png'), fit: BoxFit.cover),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------
  //-> Button for sign in
  Widget Login() {
    return Container(
      padding: EdgeInsets.only(right: 55.0, left: 55.0),
      width: MediaQuery.of(context).size.width * 0.6,
      child: RaisedButton(
        color: Color(0xFFFFCB47),
        child: Text(
          "login".tr().toString(),
          style: TextStyle(fontSize: 20.0.sp, color: Colors.black),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        onPressed: SignInFunction,
      ),
    );
  }

  //----------------------------------------------------------------------------
  //-> Flatted Button for forget password
  Widget forgetPassword() {
    return Container(
      width: MediaQuery.of(context).size.width, // take all space available
      child: FlatButton(
        onPressed: () {},
        child: Text('forget'),
      ),
    );
  }

  //----------------------------------------------------------------------------
  //-> I am new User Sign up
  Widget Signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Text("iamnewuser".tr().toString()),
        ),
        Container(
          child: FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, Register.id);
              //  Get.to(Register.id);
            },
            child: Text(
              'signup'.tr().toString(),
              style: TextStyle(color: Color(0xFFFFB005), fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------
  //-> Container for having all elements with sign in and username
  Widget sign_in_Container() {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 6.0.h,
            ),
            Text(
              "signin".tr().toString(),
              style:
                  TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.bold, color: Colors.black38),
            ),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: "phone".tr().toString(),
              //label_text: "username",
              controller_text: _phonecontroller,
              show_password: false,
              error_msg: validatePhone ? "valuecannotbeempty".tr().toString() : null,
              FunctionToDo: () {},
            ),
            SizedBox(
              height: 3.0.h,
            ),
            // it must be another textinputfield
            TextInputFieldWithIcon(
              hint_text: "password".tr().toString(),
              // label_text: "password",
              controller_text: _passwordcontroller,
              icon_widget: _isHidden ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
              show_password: _isHidden,
              error_msg: validatePassword ? "valuecannotbeempty".tr().toString() : null,
              FunctionToDo: () {
                setState(() {
                  _isHidden = !_isHidden;
                });
              },
            ),
            SizedBox(
              height: 1.0.h,
            ),
            // forgetPassword(),
            SizedBox(
              height: 1.0.h,
            ),
            // SocialButton(
            //   image: 'assets/ui/icon/facebook.png',
            //   buttonText: 'Sign in With Facebook'.tr().toString(),
            // ),
            // SocialButton(
            //   image: 'assets/ui/icon/google.png',
            //   buttonText: 'Sign in With Google'.tr().toString(),
            // ),
            Login(),
            SizedBox(
              height: 1.0.h,
            ),
            Signup(),
          ],
        ),
      ],
    );
  }
//------------------------------------------------------------------------------
} // end class
///references in getting error data from api call
///ref1 :  https://stackoverflow.com/questions/67588916/how-handle-error-from-api-request-flutter
///ref 2 :https://stackoverflow.com/questions/58920295/error-handling-an-http-request-result-in-flutter
///ref 3:https://stackoverflow.com/questions/60648984/handling-exception-http-request-flutter
