import 'dart:convert';
import 'dart:io';

import 'package:alatareekeh/constants/colors.dart';
import 'package:alatareekeh/ui/addSeekService.dart';
import 'package:alatareekeh/ui/maps.dart';
import 'package:alatareekeh/ui/myservices.dart';
import 'package:alatareekeh/ui/search.dart';
import 'package:alatareekeh/ui/seekservice.dart';
import 'package:alatareekeh/ui/signin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import 'checkappversion.dart';
import 'myappointments.dart';
import 'seekedServices.dart';

class Navigation extends StatefulWidget {
  static const id = 'navigation';
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  ColorsApp colorsApp = new ColorsApp();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int selectedPage = 0;
  PageController pageController;
  //-> list Pages
  final ImagePicker _picker = new ImagePicker();
  File imageFile;
  String imageFilePath;
  String image64;
  //------------------------Get the image from the gallery-------------------
  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      //-> if the user didn't select any image
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        imageFilePath = pickedFile.path;
      } else {
        // display message for selecting image
      }
    });
    // encode image to base64 for saving it as string
    final bytes = await imageFile.readAsBytes();
    image64 = base64Encode(bytes);
    print(image64);

    //String base64Encode(List<int> bytes) => base64.encode(bytes);
  }

  //***************************Init State**************************************
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  //---------------------------List of Pages------------------------------------
  final List<Widget> _pages = [
    Maps(),
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
    return SafeArea(
      child: Scaffold(
        extendBody: true, // very important to make the
        /*
        appBar: AppBar(
          elevation: 0,

          backgroundColor: Colors.transparent,
          title: Text(
            "onwayapp".tr().toString(),
            style: TextStyle(color: Colors.black),
          ),
          // actions: [
          //   //-> update all app
          //   IconButton(
          //       icon: Icon(Icons.refresh),
          //       onPressed: () {
          //         setState(() {});
          //       })
          // ],
        ),
        */ // disable app bar

        key: _drawerKey,
        body: PageView(
          children: _pages,
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed, // to make it unsizable
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'provided'.tr().toString()),
            BottomNavigationBarItem(icon: Icon(Icons.car_rental), label: 'seeked'.tr().toString()),
            BottomNavigationBarItem(
                icon: Icon(Icons.date_range), label: 'myappointments'.tr().toString()),
          ],
          currentIndex: selectedPage,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.black,
          selectedItemColor: colorsApp.selectedColor,
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          backgroundColor: Colors.transparent,
          onTap: _onTapped,
        ),
        drawer: Drawer(
          child: Container(
            color: Color(0xFF232323),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 30.0.h,
                  child: DrawerHeader(
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
                ),
                profileImage(),
                ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  title: Text(
                    'search'.tr().toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, Search.id);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  title: Text(
                    'provideservice'.tr().toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, AddSeekService.id); // add service
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.car_repair,
                    color: Colors.white,
                  ),
                  title: Text(
                    'seekservice'.tr().toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, SeekService.id); // seek service
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.person_pin,
                    color: Colors.white,
                  ),
                  title: Text(
                    'myservices'.tr().toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, MyServices.id);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.update,
                    color: Colors.white,
                  ),
                  title: Text(
                    'checkforupdates'.tr().toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, CheckAppVersion.id);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  title: Text(
                    'logout'.tr().toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, SignIn.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } // end build

//--------------------------------------profile Image-------------------------------------
  Widget profileImage() {
    return InkWell(
      onTap: () async {
        getImage();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 75.0, left: 75.0),
        child: Container(
          height: 150,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.25)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: imageFile != null
                  //-> clipoval to make the image in
                  ? ClipOval(
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.cover,
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(
                      'assets/ui/icon/icon2.png',
                      fit: BoxFit.fill,
                    )),
            ),
          ),
        ),
      ),
    );
  }
} // end class
