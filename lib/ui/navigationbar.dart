import 'package:alatareekeh/ui/addSeekService.dart';
import 'package:alatareekeh/ui/myservices.dart';
import 'package:alatareekeh/ui/settings.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'myappointments.dart';
import 'seekedServices.dart';

class Navigation extends StatefulWidget {
  static const id = 'navigation';
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int selectedPage = 0;
  //-> list Pages
  final _pageOptions = [
    HomePage(), // this home page contains order or everythimg and contain a search button
    SeekedServices(),
    AddSeekService(), // add service or seek service
    MyAppointment(), // get my appointments
    MyServices(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Provided'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Seeked'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer), label: 'Add/Seek'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Appointment'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Services'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Settings'),
        ],
        currentIndex: selectedPage,
        showUnselectedLabels: true,
        unselectedItemColor: Color(0xFFB1B1B1),
        selectedItemColor: Colors.amber,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        backgroundColor: Color(0xFF707070),
        onTap: (index) {
          setState(() {
            selectedPage = index;
          });
        },
      ),
    );
  }
}
