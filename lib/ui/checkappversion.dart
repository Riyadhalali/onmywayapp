import 'package:alatareekeh/services/GetAppVersion.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'navigationbar.dart';

class CheckAppVersion extends StatefulWidget {
  static const id = 'checkapp_version';
  @override
  _CheckAppVersionState createState() => _CheckAppVersionState();
}

class _CheckAppVersionState extends State<CheckAppVersion> {
  WebServices webServices;
  String appName;
  String packageName;
  String version;
  int buildNumber;
  int appUpdateVersion; // a varriable to hold the latest update
  String appUpdateLink; // a variable to hold the link from server

  //*****************************Get App info***********************************
  void getAppinfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    packageName = packageInfo.packageName;
    version = packageInfo.version;
    buildNumber = int.parse(packageInfo
        .buildNumber); // get the build number as string and convert it to int
  }

  //---------------------------Get App Version API------------------------------
  getAppVersion() async {
    // showProcessingDialogWidget();

    GetAppVersion getAppVersion = await WebServices.Get_Version();
    appUpdateVersion =
        getAppVersion.androidVer; // return android version as int
    appUpdateLink = getAppVersion.link;
    if (buildNumber < appUpdateVersion) {
      // Navigator.of(context).pop();
      AlertDialogWidget();
    } else {
      AlertDialogNoUpdates(); // display a alert dialog howing that no updates found
    }
  }

  //-------------------------------Open URL-------------------------------------
  //https://www.google.com/
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //----------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppinfo(); // get app info from device
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("update".tr().toString()),
      ),
      body: FutureMethod(),
    );
  }

//------------------------------Future Method-----------------------------------
  Widget FutureMethod() {
    return FutureBuilder(
      future: getAppVersion(), // any future function
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());

          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return Container();
        }
      },
    );
  }

  //-----------------------------Widget Tree------------------------------------
  showProcessingDialogWidget() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            content: Container(
              width: 80.0.w,
              height: 15.0.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 5.0.w,
                ),
                Text("loading".tr().toString(),
                    style: TextStyle(
                        fontFamily: "OpenSans", color: Color(0xFF5B6978)))
              ]),
            ),
          );
        });
  }

  //------------------------Show Alert Dialog-----------------------------------
  AlertDialogWidget() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("updateavailables".tr().toString()),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text('update'.tr().toString())],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => _launchURL('https://www.google.com/'),
                child: Text("yes".tr().toString()),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(
                      context, Navigation.id); // go to home page
                },
                child: Text(
                  'cancel'.tr().toString(),
                ),
              )
            ],
          );
        });
  }

//-------------------------Alert Dialog No Updates Found------------------------
  AlertDialogNoUpdates() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("noupdatesavailable".tr().toString()),
            content: SingleChildScrollView(
              child: ListBody(
                children: [Text('update'.tr().toString())],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, Navigation.id); // go to home page
                },
                child: Text(
                  'ok'.tr().toString(),
                ),
              )
            ],
          );
        });
  }

//-----------------------------------------------------------------------------
}
//TODO: add applinkupdate for android and ios
