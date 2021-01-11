import 'package:alatareekeh/services/getseekedservices.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/addappointment.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'home/searchfield.dart';

class SeekedServices extends StatefulWidget {
  static const String id = 'seekedservices_page';

  //Customer is the user and Provider is how added the order
  final String providerUsername;
  final int providerID;
  final String providerPhone;
  final String providerGender;
  final String providerSpace;
  final String date;
  final String providerPickup;
  final String providerDistination;

  SeekedServices(
      {this.providerUsername,
      this.providerID,
      this.providerPhone,
      this.providerGender,
      this.providerSpace,
      this.date,
      this.providerPickup,
      this.providerDistination});
  @override
  _SeekedServicesState createState() => _SeekedServicesState();
}

class _SeekedServicesState extends State<SeekedServices> {
  List<GetSeekedServices> seekedServicesList; // an  object of seeked services

//-> this method will get the data in async mode
  Future<List<GetSeekedServices>> fetchSeekedList() async {
    seekedServicesList = await WebServices
        .Get_Seeked_Services(); // this method used as static method

    return seekedServicesList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            //SearchField(), //search box for seeked services
          ],
        ),
      ),
      body: FutureMethod(),
    );
  } // end build

//--------------------------------Future Method that will get the data----------
  Widget FutureMethod() {
    return FutureBuilder(
      future: fetchSeekedList(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(child: new CircularProgressIndicator());
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return RefreshIndicator(
                onRefresh: fetchSeekedList,
                child: SeekedServicesWidget(),
              );
        }
      },
    );
  }

//----------------------------------Widget Tree---------------------------------
  Widget SeekedServicesWidget() {
    return Container(
      child: ListView.builder(
        itemCount: seekedServicesList.length, // important
        itemBuilder: (context, index) {
          GetSeekedServices list = seekedServicesList[index];
          return Card(
            child: ListTile(
              onTap: () {},
              title: Text(list.userName),
              subtitle: Column(
                children: <Widget>[
                  Text(list.servicePickup + " - " + list.serviceDestination),
                  Text(list.serviceDate),
                  Text(list.serviceGender),
                  Text(list.serviceSpace)
                ],
              ),
              trailing: RaisedButton(
                onPressed: () {
                  // go to Add Appointment page and pass params
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddAppointment(
                        providerUsername: list.userName,
                        providerID: list.userId,
                        providerPhone: list.userPhone,
                        providerGender: list.serviceGender,
                        providerSpace: list.serviceSpace,
                        date: list.serviceDate,
                        providerPickup: list.servicePickup,
                        providerDistination: list.serviceDestination,
                        providerServiceId: list.serviceId.toString(),
                      ),
                    ),
                  );
                },
                child: Text('addAppointment'.tr().toString()),
              ),
            ),
          );
        },
      ),
    );
  }

//------------------------------------------------------------------------------

} // end class
