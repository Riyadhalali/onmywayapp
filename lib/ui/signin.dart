import 'dart:ui';

import 'package:alatareekeh/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';

class SignIn extends StatefulWidget {
  static const id = 'sign_in';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _usernamecontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Login',
          style: TextStyle(fontSize: 20.0.sp, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Colors.blueAccent,
          ),
        ),
        onPressed: () {
          print("Login Button is pressed");
        },
      ),
    );
  }

  //----------------------------------------------------------------------------
  //-> Flatted Button for forget password
  Widget ForgetPassword() {
    return Container(
      width: MediaQuery.of(context).size.width, // take all space available
      child: FlatButton(
        onPressed: () {},
        child: Text("Forget Password?"),
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
          child: Text('I am New User.'),
        ),
        Container(
          child: FlatButton(
            onPressed: () {
              print('Sign up pressed');
            },
            child: Text(
              'Sign up?',
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
              "Sign in",
              style: TextStyle(
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black38),
            ),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: "Username",
              controller_text: _usernamecontroller,
              show_password: false,
            ),
            SizedBox(
              height: 3.0.h,
            ),
            TextInputField(
              hint_text: "Password",
              controller_text: _passwordcontroller,
              icon_widget: Icon(Icons.remove_red_eye),
              show_password: true,
            ),
            SizedBox(
              height: 1.0.h,
            ),
            ForgetPassword(),
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
