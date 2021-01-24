import 'package:alatareekeh/ui/addSeekService.dart';
import 'package:alatareekeh/ui/myservices.dart';
import 'package:alatareekeh/ui/search.dart';
import 'package:alatareekeh/ui/seekservice.dart';
import 'package:alatareekeh/ui/signin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'checkappversion.dart';
import 'home.dart';
import 'myappointments.dart';
import 'seekedServices.dart';

class Navigation extends StatefulWidget {
  static const id = 'navigation';
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bool keepAlive = false; // a variable to keep alive
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int selectedPage = 0;
  //-> list Pages
  final _pageOptions = [
    HomePage(), // this home page contains order or everythimg and contain a search button
    SeekedServices(),
    //  AddSeekService(), // add service
    //SeekService(), //seek service
    MyAppointment(), // get my appointments
    //   MyServices(),
    // Search(),
  ];

  //***************************Init State**************************************
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //doAsyncStuff();
  }

  //*************************doAsyncTasks***********************************
  // Future doAsyncStuff() async {
  //   keepAlive = true;
  //   updateKeepAlive();
  //   // Keeping alive...
  //
  //   await Future.delayed(Duration(seconds: 10));
  //
  //   keepAlive = false;
  //   updateKeepAlive();
  //   // Can be disposed whenever now.
  // }
  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("onwayapp".tr().toString()),
      ),
      key: _drawerKey,
      body: _pageOptions[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: 'provided'.tr().toString()),
          BottomNavigationBarItem(
              icon: Icon(Icons.car_rental), label: 'seeked'.tr().toString()),
          BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              label: 'myappointments'.tr().toString()),
        ],
        currentIndex: selectedPage,
        showUnselectedLabels: true,
        unselectedItemColor: Color(0xFFB1B1B1),
        selectedItemColor: Colors.purpleAccent,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Container(
                width: 100.0.w,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/ui/splashscreen/appicon.png"),
                      fit: BoxFit.contain),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text(
                'search'.tr().toString(),
              ),
              onTap: () {
                Navigator.pushNamed(context, Search.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('provideservice'.tr().toString()),
              onTap: () {
                Navigator.pushNamed(context, AddSeekService.id); // add service
              },
            ),
            ListTile(
              leading: Icon(Icons.car_repair),
              title: Text('seekservice'.tr().toString()),
              onTap: () {
                Navigator.pushNamed(context, SeekService.id); // seek service
              },
            ),
            ListTile(
              leading: Icon(Icons.person_pin),
              title: Text('myservices'.tr().toString()),
              onTap: () {
                Navigator.pushNamed(context, MyServices.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.update),
              title: Text('checkforupdates'.tr().toString()),
              onTap: () {
                Navigator.pushNamed(context, CheckAppVersion.id);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('logout'.tr().toString()),
              onTap: () {
                Navigator.pushNamed(context, SignIn.id);
              },
            ),
          ],
        ),
      ),
    );
  } // end build

} // end class

//done
