import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

//-> this class will be a tabBar
class MyServices extends StatefulWidget {
  static const id = 'myServices';
  @override
  _MyServicesState createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('myservices'.tr().toString()),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'seeked'.tr().toString(),
              ),
              Tab(
                text: 'proivided'.tr().toString(),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Text('2018'), // Seeked Page
            Text('2019'), //Provided Service
          ],
        ),
      ),
    );
  }
}
