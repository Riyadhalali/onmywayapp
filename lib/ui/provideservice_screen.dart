import 'package:alatareekeh/components/textinputfieldwithiconroundedcorners.dart';
import 'package:alatareekeh/components/timedatepicker.dart';
import 'package:alatareekeh/components/togglebutton2.dart';
import 'package:alatareekeh/constants/colors.dart';
import 'package:alatareekeh/provider/mapProvider.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/maps/map_picker_from.dart';
import 'package:alatareekeh/ui/maps/map_picker_to.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//-> this page for providing service so i am a provider of services
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

  //----------------------Variables----------------------

  ColorsApp colorsApp = new ColorsApp();
  final usernameController = TextEditingController();
  var fromController = TextEditingController();
  final toController = TextEditingController();
  final spaceController = TextEditingController();
  final phoneController = TextEditingController();

//------------------------------------------------------------------------------
  //-> this method to get selected time from datetimepicker statfull widget
  // void getdatetime() async {
  //   //-> to make sure that user select date
  //   if (DateTimePickerClass.valueselected == null) {
  //     _scaffoldKey.currentState.showSnackBar(SnackBar(
  //       content: Text("pleasefillalldata".tr().toString()),
  //       duration: Duration(seconds: 3),
  //       backgroundColor: Colors.amber,
  //     ));
  //
  //     //
  //   } else {
  //     setState(() {
  //       _usernameController.text.isEmpty ? validateUsername = true : validateUsername = false;
  //
  //       _fromController.text.isEmpty ? validateFrom = true : validateFrom = false;
  //
  //       _toController.text.isEmpty ? validateTo = true : validateTo = false;
  //
  //       _spaceController.text.isEmpty ? validateSpace = true : validateSpace = false;
  //
  //       _phoneController.text.isEmpty ? validatephone = true : validatephone = false;
  //     });
  //
  //     if (validateUsername || validateFrom || validateTo || validatephone) {
  //       return;
  //     }
  //     EasyLoading.show(status: "loading".tr().toString());
  //     message = await webServices.addSeekService(
  //         userID,
  //         typeOptionDefault, // value of dropdown menu
  //         _phoneController.text,
  //         _spaceController.text,
  //         DateTimePickerClass.valueselected,
  //         dropDownMenuGender,
  //         _fromController.text,
  //         _toController.text,
  //         _usernameController.text);
  //
  //     EasyLoading.dismiss();
  //     _scaffoldKey.currentState.showSnackBar(SnackBar(
  //       backgroundColor: Colors.amber,
  //       content: Text(message),
  //       duration: Duration(seconds: 3),
  //     ));
  //   }
  // }

//------------------------------------------------------------------------------
  //-------------------------------Load User Data---------------------------------
  //-> Shared Preferences for Loading User id
  void LoadUserData() async {
    userID = await sharedPref.LoadData('userID'); // load user id from shared pref
  }

//----------------------------Init State----------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadUserData(); // shared pref
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
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
    MapProvider mapProvider = Provider.of<MapProvider>(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          addServiceTab(), // widget of the bar
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),

          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: colorsApp.timePickerBorder,
            controller_text: usernameController,
            prefixIcon: "assets/ui/addservice/username.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            hint_text: "username".tr().toString(),
            FunctionToDo: () {},
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: colorsApp.timePickerBorder,
            controller_text:
                mapProvider.addServicePageFrom, // the controller is in the provider class
            prefixIcon: "assets/ui/addservice/from.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            suffixIcon: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MapPicker.id);
              },
              icon: Icon(Icons.share_location),
            ),
            hint_text: "from".tr().toString(),
            FunctionToDo: () {
              // print("Hello");
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: colorsApp.timePickerBorder,
            controller_text:
                mapProvider.addServicePageTo, // the controller is in the provider class
            prefixIcon: "assets/ui/addservice/to.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            suffixIcon: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MapPickerTo.id);
              },
              icon: Icon(Icons.share_location),
            ),
            hint_text: "to".tr().toString(),
            FunctionToDo: () {
              print("Hello");
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: colorsApp.timePickerBorder,
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
            backgroundColor: colorsApp.timePickerBorder,
            textColor: Colors.white,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButton2("assets/ui/search/male.png", "assets/ui/search/female.png"),
                ToggleButton2("assets/ui/search/package.png", "assets/ui/search/person.png"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButton2("assets/ui/search/public.png", "assets/ui/search/private.png"),
                customInputField(), // for space
              ],
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),

          FloatingActionButton(
            onPressed: () {
              // TODO: send item to seek
            },
            backgroundColor: colorsApp.selectedColor,
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
  Widget addServiceTab() {
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
            "addseekservice".tr().toString(),
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
//               error_msg: validateUsername ? "valuecannotbeempty".tr().toString() : null,
//             ),
//             SizedBox(
//               height: 2.0.h,
//             ),
//             TextInputField(
//               hint_text: "from".tr().toString(),
//               show_password: false,
//               controller_text: _fromController,
//               error_msg: validateFrom ? "valuecannotbeempty".tr().toString() : null,
//             ),
//             SizedBox(
//               height: 2.0.h,
//             ),
//             TextInputField(
//               hint_text: "to".tr().toString(),
//               show_password: false,
//               controller_text: _toController,
//               error_msg: validateTo ? "valuecannotbeempty".tr().toString() : null,
//             ),
//             SizedBox(
//               height: 2.0.h,
//             ),
//             DateTimePickerClass(),
//             SizedBox(
//               height: 2.0.h,
//             ),
//             dropDownMenuGenderWidget(),
//             SizedBox(
//               height: 2.0.h,
//             ),
//             DropDownMenuType(),
//             SizedBox(
//               height: 2.0.h,
//             ),
//             TextInputField(
//               hint_text: 'space'.tr().toString(),
//               show_password: false,
//               controller_text: _spaceController,
//               error_msg: validateSpace ? "valuecannotbeempty".tr().toString() : null,
//             ),
//             SizedBox(
//               height: 2.0.h,
//             ),
//             TextInputField(
//               hint_text: 'phone'.tr().toString(),
//               show_password: false,
//               controller_text: _phoneController,
//               error_msg: validatephone ? "valuecannotbeempty".tr().toString() : null,
//             ),
//             SizedBox(
//               height: 2.0.h,
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
  // //-> Get Selected item from drop down menu from gender
  // Widget dropDownMenuGenderWidget() {
  //   return Row(
  //     children: [
  //       Container(
  //         padding: EdgeInsets.only(left: 50.0, right: 50.0),
  //         child: Text(
  //           "gender".tr().toString(),
  //           style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.bold, color: Colors.black38),
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
  //         items: <String>['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
  //           return DropdownMenuItem<String>(
  //             value: value,
  //             child: Text(value),
  //           );
  //         }).toList(),
  //       )
  //     ],
  //   );
  // }
  //
  // //-----------------------Drop Down Menu Widget Type---------------------------
  // Widget DropDownMenuType() {
  //   return Row(
  //     children: [
  //       Container(
  //         padding: EdgeInsets.only(left: 50.0, right: 50.0),
  //         child: Text(
  //           "type".tr().toString(),
  //           style: TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.bold, color: Colors.black38),
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
//TODO: 1- SEND ITEMS to server 2- get the location from map
