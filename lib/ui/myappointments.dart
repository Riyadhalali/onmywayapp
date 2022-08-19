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

class _MyAppointmentState extends State<MyAppointment> with AutomaticKeepAliveClientMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String user_Id;
  List<GetMyAppointments> getMyAppointments;
  bool keepAlive = true;
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
  void deleteAppoimtment(String appointmentId, int index, String service_id) async {
    var message;
    // popping the confirm dialog
    Navigator.of(context).pop();

    showProcessingDialog();

    message = await WebServices.deleteAppointment(appointmentId.toString(), service_id);

    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    //   content: Text(message),
    //   duration: Duration(seconds: 5),
    // ));

    setState(() {
      getMyAppointments.removeAt(index); // to delete the item that have been deleted from api call
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
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
                    style: TextStyle(fontFamily: "OpenSans", color: Color(0xFF5B6978)))
              ]),
            ),
          );
        });
  }

//----------------------------------Make A Phone Call---------------------------
  //-> make a phone call
  Future<void> callnow(String url) async {
    if (await canLaunch('tel:$url')) {
      await launch('tel:$url');
    } else {
      throw 'call not possible make phone call';
    }
  }

//-----------------------------Keep Alive --------------------------------------
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => keepAlive;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAppointmentList();
  }

  //----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        // appBar: AppBar(
        //   leadingWidth: MediaQuery.of(context).size.width * 0.25,
        //   leading: Row(
        //     children: [
        //       IconButton(
        //         icon: Image.asset("assets/ui/addappointment/menu.png"),
        //         onPressed: () {
        //           Scaffold.of(context).openDrawer();
        //         },
        //       ),
        //       IconButton(
        //         icon: Image.asset("assets/ui/addappointment/calendar.png"),
        //         //  size: 30.0,
        //       ),
        //     ],
        //   ),
        //   backgroundColor: Colors.white,
        //   automaticallyImplyLeading: false,
        //   title: Row(
        //     children: [
        //       Text(
        //         "myappointments".tr().toString(),
        //         style: TextStyle(color: Colors.black),
        //       ),
        //     ],
        //   ),
        //   actions: [],
        // ),
        // body: FutureMethod(),
        body: columnElements());
  } // end build

  //-------------------------------Column Elements----------------------------
  Widget columnElements() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          myAppointmentsTab(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          calendar(),
          // MyAppointmentList(),

          appointments(),
        ],
      ),
    );
  }

//-------------------Widget Calendar---------------------------
  Widget calendar() {
    return CalendarDatePicker(
      onDateChanged: (DateTime value) {},
      lastDate: DateTime.now().add(Duration(days: 30)),
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
    );
  }

  //----------------------------Bar------------------------------------------
  Widget myAppointmentsTab() {
    return Row(
      children: [
        IconButton(
          icon: Image.asset("assets/ui/addappointment/menu.png"),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        ImageIcon(
          AssetImage("assets/ui/addappointment/calendar.png"),
          size: 30.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "addseekservice".tr().toString(),
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Image(image: AssetImage("assets/ui/addappointment/bar.png")),
                ),
              ),
              // IconButton(
              //   icon: Icon(
              //     Icons.arrow_back_ios_outlined,
              //     color: Colors.amber,
              //   ),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // ),
            ],
          ),
        ),
      ],
    );
  }

//---------------------------------------Services -------------------------------
  Widget appointments() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.35,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, position) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //    color: Colors.amber,
              height: MediaQuery.of(context).size.height * 0.1,
              child: Center(
                child: Card(
                  elevation: 10,
                  borderOnForeground: false,
                  //elevation: 5,
                  child: ListTile(
                    leading: profileImage(),
                    title: Text(
                      "Kathiya",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //---------------------------------Profile------------------------------------
  //-----------------------Profile Picture  ----------------------------------------------
  Widget profileImage() {
    return Container(
      width: 50,
      height: 50,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
        child: ClipOval(
          child: Image.asset(
            'assets/ui/icon/icon2.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

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
                onRefresh: () async {
                  setState(() {
                    return true;
                  });
                },
                child: MyAppointmentList(),
              );
        }
      },
    );
  }

  //--------------------------My Appointment List-------------------------------
  Widget MyAppointmentList() {
    return Container(
        child: getMyAppointments.isEmpty
            ? Center(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'noresultsfound'.tr().toString(),
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            return 0; // just for returning data
                          });
                        },
                        child: Text(
                          'retry'.tr().toString(),
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  GetMyAppointments list = getMyAppointments[index];
                  return Card(
                    child: ListTile(
                      isThreeLine: false,
                      onTap: () {
                        // print(list.serviceId);
                      },
                      title: Text(
                        //list.providerName,
                        "Hello",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          //Text('Appointment Id:' + list.appointmentId.toString()),
                          Row(
                            children: [
                              Text(
                                'phone'.tr().toString() + ': ',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Flexible(child: Text(list.providerPhone))
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'gender'.tr().toString() + ' :',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Text(list.providerGender),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'from'.tr().toString() + ': ',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Text(list.pickupLocation),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'to'.tr().toString() + ': ',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Text(list.destination),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'date'.tr().toString() + ': ',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Flexible(
                                  child: Text(
                                      list.date)), // be cause if the date is long ot will overflow
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'space'.tr().toString() + ': ',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              Text(list.space),
                            ],
                          ),
                          //Text('Service Id:' + list.serviceId.toString())
                        ],
                      ),
                      trailing: Wrap(
                        spacing: 1,
                        runSpacing: 1.0,
                        children: <Widget>[
                          IconButton(
                            //   padding: EdgeInsets.all(0),
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
                                          children: [Text('areyousure'.tr().toString())],
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
                                            Navigator.of(context).pop(); // close the dialog
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
              ));
  }

//------------------------------------------------------------------------------
} // end class
//done
