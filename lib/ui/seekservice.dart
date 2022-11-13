import 'package:alatareekeh/components/togglebuttonpersonpackage.dart';
import 'package:alatareekeh/components/togglebuttonpublicprivate.dart';
import 'package:alatareekeh/constants/colors.dart';
import 'package:alatareekeh/provider/global.dart';
import 'package:alatareekeh/provider/mapProvider.dart';
import 'package:alatareekeh/services/sharedpref.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/maps/map_picker_from.dart';
import 'package:alatareekeh/ui/maps/map_picker_to.dart';
import 'package:alatareekeh/ui/navigationbar.dart';
import 'package:alatareekeh/utils/utils.dart';
import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  String dropdownValue = 'One';
  String dropDownMenuPersonPackage = ' '; // for package or person
  String dropDownMenuPublicPrivate = ' '; // for package or person

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime selectedDate = DateTime.now();

  Utils utils = Utils();
  //--------------------------------------------Variables------------------------------------
  ColorsApp colorsApp = new ColorsApp();
  final usernameController = TextEditingController();
  var fromController = TextEditingController();
  final toController = TextEditingController();
  final spaceController = TextEditingController();
  final phoneController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  //------------------------------------------------------------------------------
  // -> this method to get selected time from datetimepicker statfull widget
  void sendRequest() async {
    MapProvider mapProvider = Provider.of<MapProvider>(context, listen: false);

    Global globalProviders = Provider.of<Global>(context, listen: false);

    //-> for male female toggle buttons
    if (globalProviders.indexToggleButtonMalefemale == 0) {
      dropDownMenuGender = "Male";
    } else {
      dropDownMenuGender = "Female"; // index == 1 from provider
    }

    if (globalProviders.indexToggleButtonPersonPackage == 0) {
      dropDownMenuPersonPackage = "Package";
    } else {
      dropDownMenuPersonPackage = "Person"; // index == 1 from provider
    }

    if (globalProviders.indexToggleButtonPublicPrivate == 0) {
      dropDownMenuPublicPrivate = "؛Public";
    } else {
      dropDownMenuPublicPrivate = "Private"; // index == 1 from provider
    }

    setState(() {
      usernameController.text.isEmpty ? validateUsername = true : validateUsername = false;

      mapProvider.addServicePageFrom.text.isEmpty ? validateFrom = true : validateFrom = false;

      mapProvider.addServicePageTo.text.isEmpty ? validateTo = true : validateTo = false;

      spaceController.text.isEmpty ? validateSpace = true : validateSpace = false;

      phoneController.text.isEmpty ? validatephone = true : validatephone = false;
    });

    // if (validateUsername || validateFrom || validateTo || validatephone) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("please fill all data")));
    //   return;
    // }
    utils.showProcessingDialog("Loading".tr().toString(), context);
    webServices
        .addSeekService(
            userID,
            typeOptionDefault, // value of dropdown menu
            phoneController.text,
            spaceController.text,
            dateController.text + " " + timeController.text,
            dropDownMenuGender,
            mapProvider.addServicePageFrom.text,
            mapProvider.addServicePageTo.text,
            usernameController.text)
        .then((value) {
      message = value;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
      Navigator.of(context).pop();
      Navigator.pushNamed(context, Navigation.id); // if user exists go to main page
    }).catchError((onError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(onError)));
    });
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
    dateController.text = DateFormat.yMd().format(DateTime.now());

    timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();
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

  //-> function for selecting date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000, 8),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text =
            DateFormat.yMd().format(selectedDate); // to format the selected date and time
        //  print(dateController.text);
      });
    }
  }

  String _hour, _minute, _time;
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        timeController.text = _time;

        timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
      });
  }

//https://medium.flutterdevs.com/date-and-time-picker-in-flutter-72141e7531c
  //------------------------------Column Element------------------------------
  Widget columnElements() {
    MapProvider mapProvider = Provider.of<MapProvider>(context);
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
            FunctionToDo: () {},
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
            suffixIcon: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MapPicker.id);
              },
              icon: Icon(Icons.share_location),
            ),
            FunctionToDo: () {},
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: Colors.amber,
            controller_text: toController,
            prefixIcon: "assets/ui/addservice/to.png",
            show_password: false,
            suffixIcon: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MapPickerTo.id);
              },
              icon: Icon(Icons.share_location),
            ),
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
            FunctionToDo: () {},
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: colorsApp.timePickerBorder,
            controller_text: dateController, // the controller is in the provider class
            prefixIcon: "assets/ui/addservice/date.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            suffixIcon: IconButton(
              onPressed: () => _selectDate(context),
              icon: Icon(Icons.date_range),
            ),
            hint_text: "to".tr().toString(),
            FunctionToDo: () {
              print("Hello");
            },
          ),
          // DateTimePickerClass(
          //     backgroundColor: colorsApp.timePickerBorder2, textColor: Colors.black),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),

          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: colorsApp.timePickerBorder,
            controller_text: timeController, // the controller is in the provider class
            prefixIcon: "assets/ui/addservice/time.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            suffixIcon: IconButton(
              onPressed: () => _selectTime(context),
              icon: Icon(Icons.date_range),
            ),
            hint_text: "to".tr().toString(),
            FunctionToDo: () {
              print("Hello");
            },
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtonMaleFemale("assets/ui/search/male.png", "assets/ui/search/female.png"),
                ToggleButtonpersonPackage(
                    "assets/ui/search/package.png", "assets/ui/search/person.png"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtonPublicPrivate(
                    "assets/ui/search/public.png", "assets/ui/search/private.png"),
                customInputField(),
              ],
            ),
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),

          FloatingActionButton(
            onPressed: sendRequest,
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
        obscureText: false, // to show password or not
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
} //end class
//done
//TODO:L
