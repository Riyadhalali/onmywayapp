import 'package:alatareekeh/ui/seekedtab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

//-> this class will be a tabBar and it contain two tabs on is the seekedServices tab and the other is provided services.
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
                text: 'provided'.tr().toString(),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SeekedTab(), // return SeekedTab page
            Text('2019'),
          ],
        ),
      ),
    );
  }
}
