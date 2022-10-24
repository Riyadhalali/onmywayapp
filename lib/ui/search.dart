import 'package:alatareekeh/components/rasidedbutton.dart';
import 'package:alatareekeh/components/textfield.dart';
import 'package:alatareekeh/components/textinputfieldwithiconroundedcorners.dart';
import 'package:alatareekeh/components/timedatepicker.dart';
import 'package:alatareekeh/constants/colors.dart';
import 'package:alatareekeh/ui/searchresults.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../components/Button.dart';
import '../components/togglebutton.dart';
import '../components/togglebuttonmalefemale.dart';

class Search extends StatefulWidget {
  static const id = 'search_page';
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  List<bool> isSelected;
  List<bool> isSelected2;
  int serviceType = 1;
  String gender = 'male';
  final _toController = TextEditingController();
  final _fromController = TextEditingController();

  bool validateTo = false;
  bool validateFrom = false;
  String datetobesend = '0';
  ColorsApp colorApp = new ColorsApp();
  DateTimePickerClass dateTimePickerClass = new DateTimePickerClass();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = [true, false];
    isSelected2 = [true, false];
    DateTimePickerClass.valueselected =
        null; // very important because when moving from widget to widget it is keeping data but now
    // it will zero it
  }

  //---------------------------Search Data--------------------------------------
  Future SearchData() async {
    // test if controllers of text box is filled with data
    setState(() {
      _toController.text.isEmpty ? validateTo = true : validateTo = false;
      _fromController.text.isEmpty ? validateFrom = true : validateFrom = false;
      if (DateTimePickerClass.valueselected == null) {
        datetobesend = '0';
      } else {
        datetobesend = DateTimePickerClass.valueselected;
      }
    });
    print(datetobesend);
    // test if all data required is full completed make an api call
    if (validateTo || validateFrom) {
      return;
    }

    //-> pass data of required search to search page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchResults(
          serviceType: serviceType.toString(),
          from: _fromController.text,
          to: _toController.text,
          gender: gender,
          date: datetobesend,
        ),
      ),
    );
    // WebServices.Search_Services(serviceType.toString(), _fromController.text,
    //     _toController.text, gender, datetobesend);
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: columnElements(),
      ),
    );
  }
  //----------------------------Widget Tree------------------------------------

  //-----------------------------Column Elements-------------------------------
  Widget columnElements() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          searchTab(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          // sign_in_Container(),
          ToggleButton(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ToggleButtonMaleFemale("assets/ui/search/male.png", "assets/ui/search/female.png"),
                ToggleButtonMaleFemale(
                    "assets/ui/search/package.png", "assets/ui/search/person.png"),
              ],
            ),
          ),
          ToggleButtonMaleFemale("assets/ui/search/public.png", "assets/ui/search/private.png"),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          DateTimePickerClass(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          TextInputFieldWithIconRoundedCorners(
            controller_text: fromController,
            show_password: false,
            prefixIcon: "assets/ui/add/service/add_service.png",
            // icon_widget: Icon(Icons.location_on),
            hint_text: "from".tr().toString(),
            FunctionToDo: () {
              print("Hello");
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          TextInputFieldWithIconRoundedCorners(
            controller_text: toController,
            prefixIcon: "assets/ui/add/service/add_service.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            hint_text: "to".tr().toString(),
            FunctionToDo: () {
              print("Hello");
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          Button(
            colour: colorApp.buttonColor,
            textColor: Colors.black,
            onPressed: () {
              //TODO
            },
            text: "Search",
          ),
          //     TextButtonWithIcon(),
        ],
      ),
    );
  }

  //----------------------------------------------------------------------------
//-----------------------------------Search-------------------------------------
  Widget searchTab() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: ImageIcon(
            AssetImage("assets/ui/search/searchicon.png"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "search".tr().toString(),
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  //----------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  //-> Container for having all elements with sign in and username
  Widget sign_in_Container() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Color(0xFFf2f2f2),
          ),
        ),
        Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 2.0.h),
                ToggleButtons(
                    selectedColor: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(15.0),
                    borderWidth: 2.0,
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                          if (buttonIndex == index) {
                            // we get 1
                            isSelected[buttonIndex] = true;
                            serviceType = 2;
                          } else {
                            // we get zero
                            isSelected[buttonIndex] = false;
                            serviceType = 1;
                          }
                        }

                        print(serviceType); // get the index
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.car_rental),
                            Text(
                              'provided'.tr().toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.car_rental),
                            Text(
                              'seeked'.tr().toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                    isSelected: isSelected),
                SizedBox(
                  height: 2.0.h,
                ),
                ToggleButtons(
                    selectedColor: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(15.0),
                    borderWidth: 2.0,
                    onPressed: (int index2) {
                      setState(() {
                        for (int buttonIndex2 = 0;
                            buttonIndex2 < isSelected.length;
                            buttonIndex2++) {
                          if (buttonIndex2 == index2) {
                            // we get 1
                            isSelected2[buttonIndex2] = true;
                          } else {
                            // we get zero
                            isSelected2[buttonIndex2] = false;
                          }
                        }

                        print(serviceType); // get the index
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.car_rental),
                            Text(
                              'male'.tr().toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.car_rental),
                            Text(
                              'female'.tr().toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                    isSelected: isSelected2),
                SizedBox(height: 2.0.h),
                DateTimePickerClass(
                  backgroundColor: colorApp.timePickerBorder,
                  textColor: Colors.white,
                ),
                SizedBox(height: 2.0.h),
                TextInputField(
                  controller_text: _fromController,
                  hint_text: "from".tr().toString(),
                  show_password: false,
                  error_msg: validateFrom ? "valuecannotbeempty".tr().toString() : null,
                ),
                SizedBox(height: 2.0.h),
                TextInputField(
                  controller_text: _toController,
                  hint_text: "to".tr().toString(),
                  show_password: false,
                  error_msg: validateTo ? "valuecannotbeempty".tr().toString() : null,
                ),
                SizedBox(height: 2.0.h),
                RasiedButton(
                  labeltext: "search".tr().toString(),
                  FunctionToDO: SearchData,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  //----------------------------------------------------------------------------

}
//done

/*
class _SearchState extends State<Search> {
  List<bool> isSelected;
  List<bool> isSelected2;
  int serviceType = 1;
  String gender = 'male';
  final _toController = TextEditingController();
  final _fromController = TextEditingController();

  bool validateTo = false;
  bool validateFrom = false;
  String datetobesend = '0';
  DateTimePickerClass dateTimePickerClass = new DateTimePickerClass();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = [true, false];
    isSelected2 = [true, false];
    DateTimePickerClass.valueselected =
        null; // very important because when moving from widget to widget it is keeping data but now
    // it will zero it
  }

  //---------------------------Search Data--------------------------------------
  Future SearchData() async {
    // test if controllers of text box is filled with data
    setState(() {
      _toController.text.isEmpty ? validateTo = true : validateTo = false;
      _fromController.text.isEmpty ? validateFrom = true : validateFrom = false;
      if (DateTimePickerClass.valueselected == null) {
        datetobesend = '0';
      } else {
        datetobesend = DateTimePickerClass.valueselected;
      }
    });
    print(datetobesend);
    // test if all data required is full completed make an api call
    if (validateTo || validateFrom) {
      return;
    }

    //-> pass data of required search to search page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchResults(
          serviceType: serviceType.toString(),
          from: _fromController.text,
          to: _toController.text,
          gender: gender,
          date: datetobesend,
        ),
      ),
    );
    // WebServices.Search_Services(serviceType.toString(), _fromController.text,
    //     _toController.text, gender, datetobesend);
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('search'.tr().toString()),
      ),
      body: columnElements(),
    );
  }
  //----------------------------Widget Tree------------------------------------

  //-----------------------------Column Elements-------------------------------
  Widget columnElements() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ImageBackground(
              assetImage: 'assets/ui/search/search.png',
            ),
            sign_in_Container(),
          ],
        ),
      ),
    );
  }
  //----------------------------------------------------------------------------

  //-> Container for having all elements with sign in and username
  Widget sign_in_Container() {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Color(0xFFf2f2f2),
          ),
        ),
        Container(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 2.0.h),
                ToggleButtons(
                    selectedColor: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(15.0),
                    borderWidth: 2.0,
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < isSelected.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            // we get 1
                            isSelected[buttonIndex] = true;
                            serviceType = 2;
                          } else {
                            // we get zero
                            isSelected[buttonIndex] = false;
                            serviceType = 1;
                          }
                        }

                        print(serviceType); // get the index
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.car_rental),
                            Text(
                              'provided'.tr().toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.car_rental),
                            Text(
                              'seeked'.tr().toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                    isSelected: isSelected),
                SizedBox(
                  height: 2.0.h,
                ),
                ToggleButtons(
                    selectedColor: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(15.0),
                    borderWidth: 2.0,
                    onPressed: (int index2) {
                      setState(() {
                        for (int buttonIndex2 = 0;
                            buttonIndex2 < isSelected.length;
                            buttonIndex2++) {
                          if (buttonIndex2 == index2) {
                            // we get 1
                            isSelected2[buttonIndex2] = true;
                          } else {
                            // we get zero
                            isSelected2[buttonIndex2] = false;
                          }
                        }

                        print(serviceType); // get the index
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.car_rental),
                            Text(
                              'male'.tr().toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.car_rental),
                            Text(
                              'female'.tr().toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                    isSelected: isSelected2),
                SizedBox(height: 2.0.h),
                DateTimePickerClass(),
                SizedBox(height: 2.0.h),
                TextInputField(
                  controller_text: _fromController,
                  hint_text: "from".tr().toString(),
                  show_password: false,
                  error_msg: validateFrom
                      ? "valuecannotbeempty".tr().toString()
                      : null,
                ),
                SizedBox(height: 2.0.h),
                TextInputField(
                  controller_text: _toController,
                  hint_text: "to".tr().toString(),
                  show_password: false,
                  error_msg:
                      validateTo ? "valuecannotbeempty".tr().toString() : null,
                ),
                SizedBox(height: 2.0.h),
                RasiedButton(
                  labeltext: "search".tr().toString(),
                  FunctionToDO: SearchData,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  //----------------------------------------------------------------------------

}
//done


 */
