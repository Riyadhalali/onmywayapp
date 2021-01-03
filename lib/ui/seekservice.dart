import 'package:alatareekeh/components/rasidedbutton.dart';
import 'package:alatareekeh/components/textfield.dart';
import 'package:alatareekeh/components/timedatepicker.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';

//-> this page for sekking service so i am a customer or provider
class SeekService extends StatefulWidget {
  static const id = 'seekservice';
  @override
  _SeekServiceState createState() => _SeekServiceState();
}

class _SeekServiceState extends State<SeekService> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  WebServices webServices = new WebServices();
  SharedPref sharedPref = new SharedPref();
  String userID;
  var message;
  String dropDownMenuGender =
      ""; // very important or we will get a null message when fetching api services
  String dropDownMenuType = "";
  final _usernameController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _spaceController = TextEditingController();
  final _phoneController = TextEditingController();

  int status2 = 111;

  static const Map<String, int> typeOptions = {
    "Person": 1,
    "Package": 2,
  };
  int typeOptionDefault = 2; // 2 is for seeking service
  // List<User> users = <User>[const User(1, 'Foo'), const User(2, 'Bar')];

  //-> this method to get selected time from datetimepicker statfull widget
  void getdatetime() async {
    //-> to make sure that user select date
    if (DateTimePickerClass.valueselected == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please fill or select date"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.amber,
      ));
    } else {
      EasyLoading.show(status: "Loading");
      message = await webServices.addSeekService(
          userID,
          status2,
          typeOptionDefault, // value of dropdown menu
          _phoneController.text,
          _spaceController.text,
          DateTimePickerClass.valueselected,
          dropDownMenuGender,
          _fromController.text,
          _toController.text,
          _usernameController.text);
      print(message);

      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.amber,
        content: Text(message),
        duration: Duration(seconds: 3),
      ));
    }
    EasyLoading.dismiss();
  }

//-------------------------------Load User Data---------------------------------
  //-> Shared Preferences for Loading User id
  void LoadUserData() async {
    userID =
        await sharedPref.LoadData('userID'); // load user id from shared pref
    print(userID);
  }

//----------------------------Init State----------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadUserData(); // shared pref
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'seekservice'.tr().toString(),
        ),
      ),
      body: columnElements(),
    );
  } // end build

  //------------------------------Column Element------------------------------
  Widget columnElements() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            addSeekServiceContainer(),
          ],
        ),
      ),
    );
  }

//------------------------------Add Seek Service----------------------------
//-> Add or Seek Sevice Container
  Widget addSeekServiceContainer() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Color(0xFFf2f2f2),
          ),
        ),
        Column(
          children: [
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'Username',
              show_password: false,
              controller_text: _usernameController,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'From',
              show_password: false,
              controller_text: _fromController,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'To',
              show_password: false,
              controller_text: _toController,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            DateTimePickerClass(),
            SizedBox(
              height: 2.0.h,
            ),
            dropDownMenuGenderWidget(),
            SizedBox(
              height: 2.0.h,
            ),
            DropDownMenuType(),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'Space',
              show_password: false,
              controller_text: _spaceController,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'Phone ',
              show_password: false,
              controller_text: _phoneController,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            RasiedButton(
              labeltext: "submit".tr().toString(),
              FunctionToDO: getdatetime,
            ),
          ],
        ),
      ],
    );
  }

  //----------------------------------------------------------------------------
  //-> Get Selected item from drop down menu from gender
  Widget dropDownMenuGenderWidget() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 50.0, right: 50.0),
          child: Text(
            "gender".tr().toString(),
            style: TextStyle(
                fontSize: 20.0.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black38),
          ),
        ),
        SizedBox(
          width: 20.0.w,
        ),
        new DropdownButton<String>(
          value: "male".tr().toString(),
          items: <String>[
            'male'.tr().toString(),
            'female'.tr().toString(),
          ].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(
                value,
                style: TextStyle(fontSize: 15.0.sp),
              ),
            );
          }).toList(),
          onChanged: (String value1) {
            setState(() {
              dropDownMenuGender = value1;
            });
          },
        )
      ],
    );
  }

  //-----------------------Drop Down Menu Widget Type---------------------------
  Widget DropDownMenuType() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.only(left: 50.0, right: 50.0),
          child: Text(
            "type".tr().toString(),
            style: TextStyle(
                fontSize: 20.0.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black38),
          ),
        ),
        SizedBox(
          width: 20.0.w,
        ),
        new DropdownButton<int>(
          items: typeOptions
              .map(
                (description, value) {
                  return MapEntry(
                    description,
                    DropdownMenuItem<int>(
                      value: value,
                      child: Text(description),
                    ),
                  );
                },
              )
              .values
              .toList(),
          value: typeOptionDefault,
          onChanged: (newValue) {
            setState(() {
              typeOptionDefault = newValue;
              print(typeOptionDefault);
            });
          },
        ),
      ],
    );
  }
//------------------------------------------------------------------------------
} //end class

//Todo: check what is the status
