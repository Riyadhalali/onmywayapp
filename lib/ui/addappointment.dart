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

  AddAppointment(
      {this.providerUsername,
      this.providerID,
      this.providerPhone,
      this.providerGender,
      this.providerSpace,
      this.date,
      this.providerPickup,
      this.providerDistination});

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
    customerID = await sharedPref.LoadData('userID');
    customerUsername = await sharedPref.LoadData('username');
    customerPhone = await sharedPref.LoadData('phone');
    customerGender = await sharedPref.LoadData('gender');
  }

//-> get the location of this device
  void GetLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    longitude = position.longitude;
    latitude = position.latitude;
  }

  //-> add the appointment
  void submitAppointment() async {
    // print(widget.providerID);
    EasyLoading.show(
      status: 'Loading...',
    );
    var messageResponse;
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
        longitude.toString());

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(messageResponse),
      duration: Duration(seconds: 3),
    ));

    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadUserDate();
    GetLocation(); // get location of user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ColumnElements(),
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
                      'Username'.tr().toString(),
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

//TODO: check server response
