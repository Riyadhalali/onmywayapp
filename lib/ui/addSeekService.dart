import 'package:alatareekeh/components/rasidedbutton.dart';
import 'package:alatareekeh/components/textfield.dart';
import 'package:alatareekeh/components/timedatepicker.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';

//-> this page for adding or sekking service so i am a customer or provider
class AddSeekService extends StatefulWidget {
  static const id = 'addSeekService';
  @override
  _AddSeekServiceState createState() => _AddSeekServiceState();
}

class _AddSeekServiceState extends State<AddSeekService> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  WebServices webServices = new WebServices();
  SharedPref sharedPref = SharedPref();
  var message;
  String dropDownMenuGender =
      'Male'; // very important or we will get a null message when fetching api services
  String dropDownMenuType = "";
  final _usernameController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _spaceController = TextEditingController();
  final _phoneController = TextEditingController();
  String userID;
  int status2 = 111;
  bool validateUsername = false;
  bool validateFrom = false;
  bool validateTo = false;
  bool validateSpace = false;
  bool validatephone = false;

  static const Map<String, int> typeOptions = {
    "Person": 1,
    "Package": 2,
  };
  int typeOptionDefault = 1; // one is for adding service
  String dropdownValue = 'One';
  // List<User> users = <User>[const User(1, 'Foo'), const User(2, 'Bar')];
//------------------------------------------------------------------------------
  //-> this method to get selected time from datetimepicker statfull widget
  void getdatetime() async {
    //-> to make sure that user select date
    if (DateTimePickerClass.valueselected == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Please fill or select date"),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.amber,
      ));

      //
    } else {
      setState(() {
        _usernameController.text.isEmpty
            ? validateUsername = true
            : validateUsername = false;

        _fromController.text.isEmpty
            ? validateFrom = true
            : validateFrom = false;

        _toController.text.isEmpty ? validateTo = true : validateTo = false;

        _spaceController.text.isEmpty
            ? validateSpace = true
            : validateSpace = false;

        _phoneController.text.isEmpty
            ? validatephone = true
            : validatephone = false;
      });

      if (validateUsername ||
          validateFrom ||
          validateTo ||
          validateSpace ||
          validatephone) {
        return;
      }
      EasyLoading.show(status: "Loading");
      message = await webServices.addSeekService(
          userID,
          typeOptionDefault, // value of dropdown menu
          _phoneController.text,
          _spaceController.text,
          DateTimePickerClass.valueselected,
          dropDownMenuGender,
          _fromController.text,
          _toController.text,
          _usernameController.text);

      print("Started add Appointment");
      print(userID);

      EasyLoading.dismiss();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.amber,
        content: Text(message),
        duration: Duration(seconds: 3),
      ));
    }
  }

//------------------------------------------------------------------------------
  //-------------------------------Load User Data---------------------------------
  //-> Shared Preferences for Loading User id
  void LoadUserData() async {
    userID =
        await sharedPref.LoadData('userID'); // load user id from shared pref
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
        backgroundColor: Color(0xFF8949d8),
        title: Text(
          'addseekservice'.tr().toString(),
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
              error_msg: validateUsername
                  ? "valuecannotbeempty".tr().toString()
                  : null,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'From',
              show_password: false,
              controller_text: _fromController,
              error_msg:
                  validateFrom ? "valuecannotbeempty".tr().toString() : null,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'To',
              show_password: false,
              controller_text: _toController,
              error_msg:
                  validateTo ? "valuecannotbeempty".tr().toString() : null,
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
              error_msg:
                  validateSpace ? "valuecannotbeempty".tr().toString() : null,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'Phone ',
              show_password: false,
              controller_text: _phoneController,
              error_msg:
                  validatephone ? "valuecannotbeempty".tr().toString() : null,
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
          value: dropDownMenuGender,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropDownMenuGender = newValue;
            });
          },
          items: <String>['Male', 'Female']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
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
