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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String user_Id;
  List<GetMyAppointments> getMyAppointments;
  SharedPref sharedPref = SharedPref();
  WebServices webServices = WebServices();
  //-------------------------Functions------------------------------------------
  //-> this method for getting data for server
  Future<List<GetMyAppointments>> fetchAppointmentList() async {
    user_Id = await sharedPref.LoadData('userID');
    getMyAppointments = await WebServices.Get_My_Appointments(user_Id);
    return getMyAppointments;
  }

  //-> delete appointment
  void deleteAppoimtment(String appointmentId) async {
    var message;

    message = await WebServices.deleteAppointment(appointmentId.toString());

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 5),
    ));

    Navigator.of(context).pop();
  }

  //-> show alert dialog

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                key: _refreshIndicatorKey,
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
                    onPressed: () {},
                    icon: Icon(Icons.add_location),
                  ),
                  IconButton(
                    onPressed: () {
                      return showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("areyousure".tr().toString()),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [Text('Location')],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => deleteAppoimtment(
                                      list.appointmentId.toString()),
                                  child: Text("sure".tr().toString()),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // close the dialog
                                  },
                                  child: Text(
                                    'cancel'.tr().toString(),
                                  ),
                                )
                              ],
                            );
                          });

                      // make get location of the id
                    },
                    icon: Icon(Icons.delete),
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
