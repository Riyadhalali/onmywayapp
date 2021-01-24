import 'dart:ui';

import 'package:alatareekeh/components/textfield.dart';
import 'package:alatareekeh/components/textfieldwithicon.dart';
import 'package:alatareekeh/services/GetUserInfo.dart';
import 'package:alatareekeh/services/getlogindata.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/forgetpassword.dart';
import 'package:alatareekeh/ui/navigationbar.dart';
import 'package:alatareekeh/ui/register.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';

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
  String
      usernameData; // this variable to store data returned from getUserInfo Api
  String
      userPhoneData; // this variable to store data returned from getUserInfo Api
  String
      userGenderData; // this variable to store data returned from getUserInfo Api
  final _phonecontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  WebServices webServices = new WebServices();
  SharedPref sharedPref = new SharedPref();

  bool validatePhone = false;
  bool validatePassword = false;
  bool _isHidden = false;

  // load user phone number and password from shared pref
  Future loadLoginData() async {
    phone_data = await sharedPref.LoadData('phone');
    password_data = await sharedPref.LoadData('password');
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
    WebServices webServices = WebServices();

    setState(() {
      _phonecontroller.text.isEmpty
          ? validatePhone = true
          : validatePhone = false;

      _passwordcontroller.text.isEmpty
          ? validatePassword = true
          : validatePassword = false;
    });

    if (validatePhone || validatePassword) {
      return;
    }

    EasyLoading.show(
      status: 'Loading...',
    );

    GetLoginData fmain = await webServices.LoginPost(
        _phonecontroller.text, _passwordcontroller.text);
    message = fmain.message;
    user_id = fmain.id;

    //-> get user info from server and then save it to shared pref and make sure that it already have an id
    if (user_id != null) {
      final GetUserInfo getUserInfo = await WebServices.Get_User_Info(user_id);
      usernameData = getUserInfo.username;
      userGenderData = getUserInfo.usergender;
    } else {
      return;
    }

    // show a snackbar message
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));

    if (message.toString().contains('login success')) {
      Navigator.pushNamed(
          context, Navigation.id); // if user exists go to main page
    }

    EasyLoading.dismiss();

    //-> save id to shared pref
    sharedPref.setData('userID', user_id); // save user id to shared pref
    sharedPref.setData(
        'phone', _phonecontroller.text); // save the phone number of user
    sharedPref.setData(
        'password', _passwordcontroller.text); //save the password of user

    // //-> save user profile to shared pref
    sharedPref.setData('username', usernameData); // save the username
    sharedPref.setData('gender', userGenderData); //save gender
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
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/ui/login/login.jpg'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------
  //-> Button for sign in
  Widget Login() {
    return Container(
      padding: EdgeInsets.only(right: 55.0, left: 55.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Color(0xFF8949d8),
        child: Text(
          "login".tr().toString(),
          style: TextStyle(fontSize: 20.0.sp, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Colors.blueAccent,
          ),
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
        onPressed: () {
          Navigator.pushNamed(context, ForgetPassword.id);
        },
        child: Text("forgetpassword".tr().toString()),
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
            },
            child: Text(
              'signup'.tr().toString(),
              style: TextStyle(
                  color: Color(0xFF8949d8), fontWeight: FontWeight.bold),
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
              height: 5.0.h,
            ),
            Text(
              "signin".tr().toString(),
              style: TextStyle(
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38),
            ),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: "phone".tr().toString(),
              //label_text: "username",
              controller_text: _phonecontroller,
              show_password: false,
              error_msg:
                  validatePhone ? "valuecannotbeempty".tr().toString() : null,
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
              icon_widget: _isHidden
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
              show_password: _isHidden,
              error_msg: validatePassword
                  ? "valuecannotbeempty".tr().toString()
                  : null,
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
//done
