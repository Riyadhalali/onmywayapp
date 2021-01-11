import 'package:alatareekeh/components/imageBackground.dart';
import 'package:alatareekeh/components/rasidedbutton.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sizer/sizer.dart';

class AddAppointment extends StatefulWidget {
  static const id = 'add_appointment';
  //Customer is the user and Provider is how added the order
  final String providerUsername;
  final String providerID;
  final String providerPhone;
  final String providerGender;
  final String providerSpace;
  final String date;
  final String providerPickup;
  final String providerDistination;
  final String providerServiceId;

  AddAppointment(
      {this.providerUsername,
      this.providerID,
      this.providerPhone,
      this.providerGender,
      this.providerSpace,
      this.date,
      this.providerPickup,
      this.providerDistination,
      this.providerServiceId});

  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String customerID; // load user_id from shared pref
  String customerUsername;
  String customerPhone;
  String customerGender;
  double latitude;
  double longitude;

  SharedPref sharedPref = new SharedPref();
  WebServices webServices = WebServices();

  //-> Load user Data profile
  void LoadUserDate() async {
    String id_data, username_data, phone_data, gender_data;

    id_data = await sharedPref.LoadData('userID');

    username_data = await sharedPref.LoadData('username');
    phone_data = await sharedPref.LoadData('phone');
    gender_data = await sharedPref.LoadData('gender');

    setState(() {
      customerID = id_data;
      customerUsername = username_data;
      customerPhone = phone_data;
      customerGender = gender_data;
    });
  }

//-> get the location of this device
  Future<Position> GetLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    double longitude_data = position.longitude;
    double latitude_data = position.latitude;

    print(latitude_data);
    setState(() {
      latitude = latitude_data;
      longitude = longitude_data;
    });

    return position;
  }

  //-> add the appointment
  void submitAppointment() async {
    // print(customerID);
    EasyLoading.show(
      status: 'Loading...',
    );
    var messageResponse;

    if (customerID != null &&
        latitude.toString() != null &&
        longitude.toString() != null) {
      messageResponse = await webServices.addAppointment(
          customerID,
          widget.providerID.toString(),
          customerUsername,
          widget.providerUsername,
          customerPhone,
          widget.providerPhone,
          customerGender,
          widget.providerGender,
          widget.providerPickup,
          widget.providerDistination,
          widget.date,
          widget.providerSpace,
          latitude.toString(),
          longitude.toString(),
          widget.providerServiceId);

      //TODO: how to make the api call submit waits until geto locator get the data

    } else {
      return;
      print("customerId is empty");
    }

    EasyLoading.dismiss();

    //print(messageResponse);
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(messageResponse),
      duration: Duration(seconds: 3),
    ));
  }

  //----------------------------------------------------------------------------

  @override
  void initState() {
    LoadUserDate();
    GetLocation(); // get location of user
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: latitude == null || longitude == null
          ? Container(
              child: Center(
                child:
                    CircularProgressIndicator(), // because the geolocator is taking time so the best is the wrap it with container
              ),
            )
          : ColumnElements(),
    );
  } // end build

//--------------------------Column Elements---------------------------------
  Widget ColumnElements() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ImageBackground(
              assetImage: 'assets/ui/addappointment/addappointment.jpg',
            ),
            AddAppointmetWidget(),
          ],
        ),
      ),
    );
  }

  //--------------------------Add Appointment---------------------------------
  Widget AddAppointmetWidget() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Color(0xFFf2f2f2),
          ),
        ),
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 3.0.h,
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  children: [
                    Text(
                      'username'.tr().toString(),
                      style: TextStyle(fontSize: 13.0.sp),
                    ),
                    containerData(widget.providerUsername),
                  ],
                ),
              ),
              //**********************Phone*********************************
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  children: [
                    Text(
                      'phone'.tr().toString(),
                      style: TextStyle(fontSize: 13.0.sp),
                    ),
                    containerData(widget.providerPhone),
                  ],
                ),
              ),

              //**********************Gender*********************************
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'gender'.tr().toString(),
                          style: TextStyle(fontSize: 13.0.sp),
                        ),
                        containerData(widget.providerGender),
                      ],
                    ),
                  ),
                  //*****************************Space***************************
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'space'.tr().toString(),
                          style: TextStyle(fontSize: 13.0.sp),
                        ),
                        containerData(widget.providerSpace),
                      ],
                    ),
                  ),
                ],
              ),
              //*****************************Date******************************
              Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  children: [
                    Text(
                      'date'.tr().toString(),
                      style: TextStyle(fontSize: 13.0.sp),
                    ),
                    containerData(widget.date),
                  ],
                ),
              ),
              //***************************From - To *****************************
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'from'.tr().toString(),
                          style: TextStyle(fontSize: 13.0.sp),
                        ),
                        containerData(widget.providerPickup),
                      ],
                    ),
                  ),
                  //*************************TO***************************************
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: [
                        Text(
                          'to'.tr().toString(),
                          style: TextStyle(fontSize: 13.0.sp),
                        ),
                        containerData(widget.providerDistination),
                      ],
                    ),
                  ),
                ],
              ),

              //*************************Submit and add appointment***************
              RasiedButton(
                labeltext: "submit".tr().toString(),
                FunctionToDO: submitAppointment,
              ),
            ],
          ),
        ),
      ],
    );
  }

//-----------------------------Container----------------------------------------
  Widget containerData(String txt) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: Text(
        txt,
        style: TextStyle(fontSize: 15.0.sp, fontStyle: FontStyle.italic),
      ),
    );
  }
//-----------------------------------------------------------------------------
} // end class
