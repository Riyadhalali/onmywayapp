import 'package:alatareekeh/components/timedatepicker.dart';
import 'package:alatareekeh/constants/colors.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../components/textinputfieldwithiconroundedcorners.dart';
import '../components/togglebuttonmalefemale.dart';

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
      "Male"; // very important or we will get a null message when fetching api services
  String dropDownMenuType = "";
  final _usernameController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _spaceController = TextEditingController();
  final _phoneController = TextEditingController();

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
  int typeOptionDefault = 2; // 2 is for seeking service
  //--------------------------------------------Variables------------------------------------
  ColorsApp colorsApp = new ColorsApp();
  final usernameController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final spaceController = TextEditingController();
  final phoneController = TextEditingController();

  //-> this method to get selected time from datetimepicker statfull widget
  void getdatetime() async {
    //-> to make sure that user select date
    if (DateTimePickerClass.valueselected == null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("pleasefillalldata".tr().toString()),
        duration: Duration(seconds: 3),
        backgroundColor: Colors.amber,
      ));
    } else {
      setState(() {
        _usernameController.text.isEmpty ? validateUsername = true : validateUsername = false;

        _fromController.text.isEmpty ? validateFrom = true : validateFrom = false;

        _toController.text.isEmpty ? validateTo = true : validateTo = false;

        _spaceController.text.isEmpty ? validateSpace = true : validateSpace = false;

        _phoneController.text.isEmpty ? validatephone = true : validatephone = false;
      });

      if (validateUsername || validateFrom || validateTo || validateSpace || validatephone) {
        return;
      }
      EasyLoading.show(status: "loading".tr().toString());
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
      // print(message);
      EasyLoading.dismiss();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.amber,
        content: Text(message),
        duration: Duration(seconds: 3),
      ));
    }
  }

//-------------------------------Load User Data---------------------------------
  //-> Shared Preferences for Loading User id
  void LoadUserData() async {
    userID = await sharedPref.LoadData('userID'); // load user id from shared pref
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
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: columnElements(),
      ),
    );
  } // end build

  //------------------------------Column Element------------------------------
  Widget columnElements() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          seekServiceTab(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),

          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: Colors.amber,
            controller_text: usernameController,
            prefixIcon: "assets/ui/addservice/username.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            hint_text: "username".tr().toString(),
            FunctionToDo: () {
              print("Hello");
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: Colors.amber,
            controller_text: fromController,
            prefixIcon: "assets/ui/addservice/from.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            hint_text: "from".tr().toString(),
            FunctionToDo: () {
              print("Hello");
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: Colors.amber,
            controller_text: toController,
            prefixIcon: "assets/ui/addservice/to.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            hint_text: "to".tr().toString(),
            FunctionToDo: () {
              print("Hello");
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: Colors.amber,
            controller_text: phoneController,
            prefixIcon: "assets/ui/addservice/phone.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            hint_text: "phone".tr().toString(),
            FunctionToDo: () {
              print("Hello");
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          DateTimePickerClass(
              backgroundColor: colorsApp.timePickerBorder2, textColor: Colors.black),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtonMaleFemale("assets/ui/search/male.png", "assets/ui/search/female.png"),
                ToggleButtonMaleFemale(
                    "assets/ui/search/package.png", "assets/ui/search/person.png"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtonMaleFemale(
                    "assets/ui/search/public.png", "assets/ui/search/private.png"),
                customInputField(),
              ],
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),

          FloatingActionButton(
            backgroundColor: colorsApp.timePickerBorder,
            child: Icon(
              Icons.add,
              size: 50,
            ),
          ),
          //     TextButtonWithIcon(),
        ],
      ),
    );
  }

  //----------------------------------add service tab--------------------------
  Widget seekServiceTab() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: ImageIcon(
            AssetImage("assets/ui/addservice/add_service.png"),
            size: 50.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "seekservice".tr().toString(),
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

//--------------------------------------Custom Text Input Field---------------------------------
  Widget customInputField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.27,

      // padding: EdgeInsets.all(10),
      child: TextField(
        //  autofocus: true,
        textAlign: TextAlign.center,
        obscureText: true, // to show password or not
        controller: spaceController, // the variable that will contain input user data
        decoration: InputDecoration(
          filled: true,
          //  prefixIcon: Icon(Icons.add),
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.circular(30)),
          fillColor: Color(0xFFEFEFF3),
          hintText: "space".tr().toString(),
          // errorText: "error_msg",
        ),
      ),
    );
  }

//------------------------------Add Seek Service----------------------------
//-> Add or Seek Sevice Container
//   Widget addSeekServiceContainer() {
//     return Stack(
//       children: [
//         Container(
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(50.0),
//             color: Color(0xFFf2f2f2),
//           ),
//         ),
//         Column(
//           children: [
//             SizedBox(
//               height: 2.0.h,
//             ),
//             TextInputField(
//               hint_text: 'username'.tr().toString(),
//               show_password: false,
//               controller_text: _usernameController,
//               error_msg: validateUsername
//                   ? "valuecannotbeempty".tr().toString()
//                   : null,
//             ),
//             SizedBox(
//               height: 1.0.h,
//             ),
//             TextInputField(
//               hint_text: 'from'.tr().toString(),
//               show_password: false,
//               controller_text: _fromController,
//               error_msg:
//                   validateFrom ? "valuecannotbeempty".tr().toString() : null,
//             ),
//             SizedBox(
//               height: 1.0.h,
//             ),
//             TextInputField(
//               hint_text: 'to'.tr().toString(),
//               show_password: false,
//               controller_text: _toController,
//               error_msg:
//                   validateTo ? "valuecannotbeempty".tr().toString() : null,
//             ),
//             SizedBox(
//               height: 1.0.h,
//             ),
//             DateTimePickerClass(),
//             SizedBox(
//               height: 1.0.h,
//             ),
//             dropDownMenuGenderWidget(),
//             SizedBox(
//               height: 1.0.h,
//             ),
//             DropDownMenuType(),
//             SizedBox(
//               height: 1.0.h,
//             ),
//             TextInputField(
//               hint_text: 'space'.tr().toString(),
//               show_password: false,
//               controller_text: _spaceController,
//               error_msg:
//                   validateSpace ? "valuecannotbeempty".tr().toString() : null,
//             ),
//             SizedBox(
//               height: 1.0.h,
//             ),
//             TextInputField(
//               hint_text: 'phone'.tr().toString(),
//               show_password: false,
//               controller_text: _phoneController,
//               error_msg:
//                   validatephone ? "valuecannotbeempty".tr().toString() : null,
//             ),
//             SizedBox(
//               height: 1.0.h,
//             ),
//             RasiedButton(
//               labeltext: "submit".tr().toString(),
//               FunctionToDO: getdatetime,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

  //----------------------------------------------------------------------------
  //-> Get Selected item from drop down menu from gender
  // Widget dropDownMenuGenderWidget() {
  //   return Row(
  //     children: [
  //       Container(
  //         padding: EdgeInsets.only(left: 50.0, right: 50.0),
  //         child: Text(
  //           "gender".tr().toString(),
  //           style: TextStyle(
  //               fontSize: 20.0.sp,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.black38),
  //         ),
  //       ),
  //       SizedBox(
  //         width: 20.0.w,
  //       ),
  //       new DropdownButton<String>(
  //         value: dropDownMenuGender,
  //         icon: Icon(Icons.arrow_downward),
  //         iconSize: 24,
  //         elevation: 16,
  //         style: TextStyle(color: Colors.deepPurple),
  //         underline: Container(
  //           height: 2,
  //           color: Colors.deepPurpleAccent,
  //         ),
  //         onChanged: (String newValue) {
  //           setState(() {
  //             dropDownMenuGender = newValue;
  //           });
  //         },
  //         items: <String>['Male', 'Female']
  //             .map<DropdownMenuItem<String>>((String value) {
  //           return DropdownMenuItem<String>(
  //             value: value,
  //             child: Text(value),
  //           );
  //         }).toList(),
  //       )
  //     ],
  //   );
  // }

  //-----------------------Drop Down Menu Widget Type---------------------------
  // Widget DropDownMenuType() {
  //   return Row(
  //     children: [
  //       Container(
  //         padding: EdgeInsets.only(left: 50.0, right: 50.0),
  //         child: Text(
  //           "type".tr().toString(),
  //           style: TextStyle(
  //               fontSize: 20.0.sp,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.black38),
  //         ),
  //       ),
  //       SizedBox(
  //         width: 20.0.w,
  //       ),
  //       new DropdownButton<int>(
  //         items: typeOptions
  //             .map(
  //               (description, value) {
  //                 return MapEntry(
  //                   description,
  //                   DropdownMenuItem<int>(
  //                     value: value,
  //                     child: Text(description),
  //                   ),
  //                 );
  //               },
  //             )
  //             .values
  //             .toList(),
  //         value: typeOptionDefault,
  //         onChanged: (newValue) {
  //           setState(() {
  //             typeOptionDefault = newValue;
  //             print(typeOptionDefault);
  //           });
  //         },
  //       ),
  //     ],
  //   );
  // }
//------------------------------------------------------------------------------
} //end class
//done
