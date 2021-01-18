import 'package:alatareekeh/services/getmyappointments.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/maps.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

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

//---------------------------Delete Appointment--------------------------------
  //-> delete appointment
  void deleteAppoimtment(
      String appointmentId, int index, String service_id) async {
    var message;
    // popping the confirm dialog
    Navigator.of(context).pop();

    showProcessingDialog();

    message = await WebServices.deleteAppointment(
        appointmentId.toString(), service_id);

    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    //   content: Text(message),
    //   duration: Duration(seconds: 5),
    // ));

    setState(() {
      getMyAppointments.removeAt(
          index); // to delete the item that have been deleted from api call
    });

    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);

    Navigator.of(context).pop();
  }

  //-----------------------Show Processing Dialog-------------------------------
  void showProcessingDialog() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            content: Container(
              width: 80.0.w,
              height: 15.0.h,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 5.0.w,
                ),
                Text("deleting".tr().toString(),
                    style: TextStyle(
                        fontFamily: "OpenSans", color: Color(0xFF5B6978)))
              ]),
            ),
          );
        });
  }

//----------------------------------Make A Phone Call---------------------------
  //-> make a phone call
  Future<void> callnow(String url) async {
    if (await canLaunch(url)) {
      await launch('tel:$url');
    } else {
      throw 'call not possible make phone call';
    }
  }

//------------------------------------------------------------------------------

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
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   title: Text("myappointments".tr().toString()),
      // ),
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
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: getMyAppointments.length,
        itemBuilder: (context, index) {
          GetMyAppointments list = getMyAppointments[index];
          return Card(
            child: ListTile(
              isThreeLine: false,
              onTap: () {
                // print(list.serviceId);
              },
              title: Text(
                list.providerName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue),
              ),
              subtitle: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //Text('Appointment Id:' + list.appointmentId.toString()),
                    Row(
                      children: [
                        Text(
                          'phone'.tr().toString() + ': ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(list.customerPhone)
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'gender'.tr().toString() + ' :',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(list.customerGender),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'from'.tr().toString() + ': ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(list.pickupLocation),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'to'.tr().toString() + ': ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(list.destination),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'date'.tr().toString() + ': ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Flexible(
                            child: Text(list
                                .date)), // be cause if the date is long ot will overflow
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'space'.tr().toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        Text(list.space),
                      ],
                    ),
                    //Text('Service Id:' + list.serviceId.toString())
                  ],
                ),
              ),
              trailing: Wrap(
                spacing: 5,
                children: [
                  IconButton(
                    onPressed: () async {
                      //get the lat and long from service and then pass it to the map ui
                      var lat, long;
                      // GetServiceLocation getServiceLocation =
                      // await WebServices.Get_Service_Location(
                      //     list.appointmentId.toString());
                      // lat = getServiceLocation.lat;
                      // long = getServiceLocation.lon;

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Maps(
                            appointmentId: list.appointmentId.toString(),

                            // latitudePassed: lat,
//                            ),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.add_location),
                  ),
                  IconButton(
                    onPressed: () {
                      return showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("delete".tr().toString()),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: [
                                    Text('areyousure'.tr().toString())
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => deleteAppoimtment(
                                      list.appointmentId.toString(),
                                      index,
                                      list.serviceId.toString()),
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
                  IconButton(
                    icon: Icon(Icons.call),
                    onPressed: () => callnow(list.customerPhone),
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
//done
