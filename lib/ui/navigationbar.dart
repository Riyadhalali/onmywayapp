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
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int selectedPage = 0;
  PageController pageController;
  //-> list Pages

  //***************************Init State**************************************
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  //---------------------------List of Pages------------------------------------
  final List<Widget> _pages = [
    HomePage(),
    SeekedServices(),
    MyAppointment(),
  ];
  //--------------------------On Tapped item-----------------------------------
  _onTapped(int index) {
    setState(() {
      selectedPage = index;
      pageController.jumpToPage(index);
    });
  }
  //------------------------On Page Changed-------------------------------------

  void onPageChanged(int page) {
    setState(() {
      this.selectedPage = page;
    });
  }
  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("onwayapp".tr().toString()),
        // actions: [
        //   //-> update all app
        //   IconButton(
        //       icon: Icon(Icons.refresh),
        //       onPressed: () {
        //         setState(() {});
        //       })
        // ],
      ),
      key: _drawerKey,
      body: PageView(
        children: _pages,
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // to make it unsizable
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
        onTap: _onTapped,
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
