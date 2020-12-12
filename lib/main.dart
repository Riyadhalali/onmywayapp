import 'package:alatareekeh/ui/splash.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData.light(),
      home: SplashScreen(),
    );
  }
}
