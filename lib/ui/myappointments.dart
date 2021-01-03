import 'package:alatareekeh/services/getmyappointments.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyAppointment extends StatefulWidget {
  static const id = 'myAppointments';
  @override
  _MyAppointmentState createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {
  String user_Id;
  List<GetMyAppointments> getMyAppointments;
  SharedPref sharedPref = SharedPref();
  //-------------------------Functions------------------------------------------
  //-> this method for getting data for server
  Future<List<GetMyAppointments>> fetchAppointmentList() async {
    getMyAppointments = await WebServices.Get_My_Appointments(user_Id);
    return getMyAppointments;
  }

  //-> this method for loading user id from shared preferences
  void LoadUserData() async {
    user_Id = await sharedPref.LoadData('userID');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadUserData(); // load user id from shared pref
  }

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("myappointments".tr().toString()),
      ),
      body: FutureMethod(),
    );
  } // end build

//-------------------------Future Method----------------------------------------
  Widget FutureMethod() {
    return FutureBuilder(
      future: fetchAppointmentList(), // any future function
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
                onRefresh: fetchAppointmentList,
                child: MyAppointmentList(),
              );
        }
      },
    );
  }

  //--------------------------My Appointment List-------------------------------
  Widget MyAppointmentList() {
    return Container(
      child: ListView.builder(
        itemCount: getMyAppointments.length,
        itemBuilder: (context, index) {
          GetMyAppointments list = getMyAppointments[index];
          return Card(
            child: ListTile(
              isThreeLine: false,
              onTap: () {
                print(list.providerId);
              },
              title: Text(list.providerName),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text('Phone: ' + list.providerPhone),
                  Text('Gender: ' + list.providerGender),
                  Text('From: ' + list.pickupLocation),
                  Text('To: ' + list.destination),
                  Text('Date: ' + list.date),
                  Text('Space: ' + list.space),
                ],
              ),
              trailing: Wrap(
                spacing: 5,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_location),
                  ),
                ],
              ),
            ),
            borderOnForeground: true,
          );
        },
      ),
    );
  }

//------------------------------------------------------------------------------
} // end class
