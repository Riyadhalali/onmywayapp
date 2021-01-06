import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/ui/signin.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrivacyPolicy extends StatefulWidget {
  static String id = 'privacy_policy';
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  bool _checked = false;
  SharedPref sharedPref = SharedPref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: columnElements(),
    );
  } // end build

//------------------------------------------------------------------------------
//-----------------------------Widget Tree--------------------------------------
  Widget columnElements() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 5.0.h,
          ),
          imageBackground(),
          PrivacyPolicyText(),
          AcceptPrivacyPolicyRadioButton(),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
  //-> Widget of background
  Widget imageBackground() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/ui/privacypolicy/privacypolicy.jpg'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  //-> Widget of privacy policy text

  Widget PrivacyPolicyText() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35.0.h,
      padding: EdgeInsets.only(right: 25.0, left: 25.0),
      color: Colors.grey.shade100,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text(
          "Hello this is privacy policy of app please be acrefull about everything" +
              "Hello this is privacy policy of app please be acrefull about everything." +
              "Hello this is privacy policy of app please be acrefull about everything." +
              "Hello this is privacy policy of app please be acrefull about everything." +
              "Hello this is privacy policy of app please be acrefull about everything.",
          style: TextStyle(fontSize: 20.0.sp),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------
//-> Accept Privacy Policy
  Widget AcceptPrivacyPolicyRadioButton() {
    return Container(
      alignment: Alignment.bottomLeft,
      width: 100.0.w,
      color: Colors.transparent,
      height: 7.0.h,
      child: CheckboxListTile(
        activeColor: Colors.black87,
        controlAffinity:
            ListTileControlAffinity.leading, // to make checkbox left aligned
        title: Text(
          "Accept Privacy Policy",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 18.0.sp,
            color: Colors.black,
          ),
        ),
        secondary: Icon(Icons.privacy_tip),
        value: _checked,
        onChanged: (bool value) {
          setState(() {
            _checked = value;
            if (_checked == true) {
              sharedPref.setData('privacypolicystate',
                  'privacypolicyaccepted'); // saving privacy policy accept to shared pref
              Navigator.pushNamed(
                  context, SignIn.id); // navigate to login in screen
            }
          });
        },
      ),
    );
  }
//------------------------------------------------------------------------------
} // end class
