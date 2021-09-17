import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/ui/privacypolicy.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LanguageSelect extends StatefulWidget {
  static String id = 'language_select'; // id for screen
  @override
  _LanguageSelectState createState() => _LanguageSelectState();
}

class _LanguageSelectState extends State<LanguageSelect> {
  SharedPref sharedPref = new SharedPref();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: columnElements(),
      ),
    );
  } // end build

//-----------------------------Widget Tree--------------------------------------
  Widget columnElements() {
    return SingleChildScrollView(
      child: Column(
        children: [
          imageBackground(),
          SizedBox(
            height: 7.0.h,
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width,
          //   child: TyperAnimatedTextKit(
          //     onTap: () {
          //       print("Tap Event");
          //     },
          //     text: [
          //       "onwayapp".tr().toString(),
          //       "Welcome .. ",
          //       "Please Select your Language",
          //     ],
          //     textStyle: TextStyle(fontSize: 23.0.sp, fontFamily: "Bobbers"),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          SizedBox(
            height: 5.0.h,
          ),
          EnglishLangugae(),
          ArabicLanguage(),
        ],
      ),
    );
  }

//------------------------------------------------------------------------------
  Widget imageBackground() {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/ui/selectlanguage/selectlanguage.png'), fit: BoxFit.cover),
        ),
      ),
    );
  }

//------------------------------------------------------------------------------
  Widget EnglishLangugae() {
    return Container(
      padding: EdgeInsets.all(25.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.12,
      // height: MediaQuery.of(context).size.height * 0.12,
      child: ElevatedButton(
        onPressed: selectEnglish,
        child: Text(
          'english'.tr().toString(),
          style: TextStyle(fontSize: 20.0.sp),
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            primary: Color(0xFF707070)),
      ),
    );
  }

//------------------------------------------------------------------------------
  Widget ArabicLanguage() {
    return Container(
      padding: EdgeInsets.all(25.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.12,
      child: ElevatedButton(
        onPressed: selectArabic,
        child: Text(
          'arabic'.tr().toString(),
          style: TextStyle(fontSize: 20.0.sp),
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            primary: Color(0xFF707070)),
      ),
    );
  }

//------------------------------------------------------------------------------
//-> Functions

  void selectEnglish() {
    setState(() {
      // context.locale = Locale("en"); // set language to English
      context.setLocale(Locale('en')); // setting language of the device in the new packae
      sharedPref.setData('selectedlanguage', 'en');
      Navigator.pushNamed(context, PrivacyPolicy.id); // navigate to Select Language screen
    });
  }

  void selectArabic() {
    setState(() {
      //  context.locale = Locale("ar"); // set language to English
      context.setLocale(Locale('ar')); // set the language using new easy localization methods
      sharedPref.setData('selectedlanguage', 'ar');
      Navigator.pushNamed(context, PrivacyPolicy.id); // navigate to Select Language screen
    });
  }

//---------------------------------------------------------------------------
} //end class
//done
