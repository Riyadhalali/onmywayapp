import 'package:alatareekeh/ui/forgetpassword.dart';
import 'package:alatareekeh/ui/home.dart';
import 'package:alatareekeh/ui/languageselect.dart';
import 'package:alatareekeh/ui/privacypolicy.dart';
import 'package:alatareekeh/ui/register.dart';
import 'package:alatareekeh/ui/signin.dart';
import 'package:alatareekeh/ui/splash.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() => runApp(
      EasyLocalization(
          supportedLocales: [Locale('en'), Locale('ar')],
          path: 'assets/resources/strings', // <-- change patch to your
          child: MyApp()),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      //return LayoutBuilder
      builder: (context, constraints) {
        return OrientationBuilder(
          //return OrientationBuilder
          builder: (context, orientation) {
            var lang = context.locale.toString(); // get lang of app
            print('your app language is:$lang');
            //initialize SizerUtil()
            SizerUtil().init(constraints, orientation); //initialize SizerUtil
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              initialRoute:
                  SplashScreen.id, // the default screen that will start
              theme: ThemeData.light(),
              routes: {
                //-> we must add all routes
                SplashScreen.id: (context) => SplashScreen(),
                LanguageSelect.id: (context) => LanguageSelect(),
                PrivacyPolicy.id: (context) =>
                    PrivacyPolicy(), // privacy policy route screen
                HomePage.id: (context) => HomePage(),
                SignIn.id: (context) => SignIn(),
                Register.id: (context) => Register(),
                ForgetPassword.id: (context) => ForgetPassword()
              },
            );
          },
        );
      },
    );
  }
}
