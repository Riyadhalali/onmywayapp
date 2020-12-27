import 'package:alatareekeh/services/getseekedservices.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:flutter/material.dart';

import 'home/searchfield.dart';

class SeekedServices extends StatefulWidget {
  static const String id = 'seekedservices_page';
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
            SearchField(), //search box for seeked services
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
                  print('تم الحجز');
                },
                child: Text('حجز'),
              ),
            ),
          );
        },
      ),
    );
  }

//------------------------------------------------------------------------------

} // end class
