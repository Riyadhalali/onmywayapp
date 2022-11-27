import 'package:alatareekeh/components/Button.dart';
import 'package:alatareekeh/components/textinputfieldwithiconroundedcorners.dart';
import 'package:alatareekeh/components/timedatepicker.dart';
import 'package:alatareekeh/constants/colors.dart';
import 'package:alatareekeh/services/GetSearchResults.dart';
import 'package:alatareekeh/services/webservices.dart';
import 'package:alatareekeh/ui/maps/map_picker_search_from.dart';
import 'package:alatareekeh/ui/maps/map_picker_search_to.dart';
import 'package:alatareekeh/ui/searchresults.dart';
import 'package:alatareekeh/utils/utils.dart';
import 'package:date_format/date_format.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/mapProvider.dart';

class Search extends StatefulWidget {
  static const id = 'search_page';
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  List<bool> isSelected;
  List<bool> isSelected2;
  int serviceType = 1;
  String gender = 'male';
  String genderType = "";
  String carryType = "";
  String privacyType = "";
  final _toController = TextEditingController();
  final _fromController = TextEditingController();
  bool changeColor = false;
  bool changeColor2 = false;
  bool changeColor3 = false;
  bool validateTo = false;
  bool validateFrom = false;
  String datetobesend;
  ColorsApp colorApp = new ColorsApp();
  DateTimePickerClass dateTimePickerClass = new DateTimePickerClass();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  DateTime selectedDate = DateTime.now();
  Utils utils = Utils();

  List<bool> isSelectedServiceType;
  List<bool> isSelectedGenderType;
  List<bool> isSelectedCarryType;
  List<bool> isSelectedPrivacyType;

  MapProvider _mapProvider;
  WebServices webServices = new WebServices();

  List<GetSearchResults> searchResultsList;

  @override
  void dispose() {
    super.dispose();
    _mapProvider.clearData(); // defined in init state then called here
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = [true, false];
    isSelected2 = [true, false];
    isSelectedServiceType = [true, false];
    isSelectedGenderType = [true, false];
    isSelectedCarryType = [true, false];
    isSelectedPrivacyType = [true, false];

    //-> to format date and time
    dateController.text = DateFormat.yMd().format(DateTime.now());

    timeController.text = formatDate(
        DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
        [hh, ':', nn, " ", am]).toString();

    _mapProvider = Provider.of(context, listen: false);

    // it will zero it
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = displayFormater.format(displayDate);
    return formatted;
  }

  //---------------------------Search Data--------------------------------------
  Future SearchData() async {
    // test if controllers of text box is filled with data
    setState(() {
      _toController.text.isEmpty ? validateTo = true : validateTo = false;
      _fromController.text.isEmpty ? validateFrom = true : validateFrom = false;
      if (DateTimePickerClass.valueselected == null) {
        //datetobesend = '0';
      } else {
        // datetobesend = DateTimePickerClass.valueselected;
      }
    });

    datetobesend =
        DateFormat('yyyy-MM-dd H:m a').format(DateTime.parse(DateTimePickerClass.valueselected));
    //print(DateTimePickerClass.valueselected);
    print(datetobesend);
    // test if all data required is full completed make an api call
    // if (validateTo || validateFrom) {
    //   return;
    // }

    //-> pass data of required search to search page
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchResults(
          serviceType: serviceType.toString(), // provided or seeked
          from: _fromController.text,
          to: _toController.text,
          gender: gender, // male or female
          date: datetobesend,
        ),
      ),
    );
    // WebServices.Search_Services(serviceType.toString(), _fromController.text,
    //     _toController.text, gender, datetobesend);
  }

//api request
  void sendRequest() async {
    String _from = ""; // private variables
    String _to = ""; // private variables

    setState(() {
      _mapProvider.searchPageFromController.text.isEmpty
          ? validateFrom = true
          : validateFrom = false;

      _mapProvider.searchPageToController.text.isEmpty ? validateTo = true : validateTo = false;
    });

    // to make sure the user select the from and to destination
    if (validateFrom || validateTo) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("please fill data".tr().toString()),
      ));
      return; // return and don't do anything
    }

    //-> if user selects maps place make from as lat and lng or if user selects place by typing name we send to server the place name

    if (_mapProvider.destinationFromSearchPageLng.isNotEmpty &&
        _mapProvider.destinationFromSearchPageLat.isNotEmpty) {
      _from = _mapProvider.destinationFromSearchPageLat +
          "," +
          _mapProvider.destinationFromSearchPageLng;
    } else {
      _from = _mapProvider.searchPageFromController.text;
    }

    if (_mapProvider.destinationToSearchPageLng.isNotEmpty &&
        _mapProvider.destinationToSearchPageLat.isNotEmpty) {
      _to = _mapProvider.destinationToSearchPageLat + "," + _mapProvider.destinationToSearchPageLng;
    } else {
      _to = _mapProvider.searchPageToController.text;
    }

    utils.showProcessingDialog("Loading".tr().toString(), context);

    searchResultsList = await WebServices.Search_Services(privacyType, _from, _to, genderType,
            dateController.text + " " + timeController.text, carryType, privacyType)
        .then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
      print(searchResultsList);
      Navigator.of(context).pop();
      //TODO: pass search results to home page and  show results on main page
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    });
  }

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
    MapProvider mapProvider = Provider.of<MapProvider>(context);
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
          toggleButtonServiceType(), // for determining service type
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [toggleButtonGenderType(), toggleButtonCarryType()],
            ),
          ),
          //ToggleButtonMaleFemale("assets/ui/search/public.png", "assets/ui/search/private.png"),
          toggleButtonPrivacyType(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.025,
          ),
          // DateTimePickerClass(),
          //dateTimePicker(),
          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: colorApp.timePickerBorder,
            controller_text: dateController, // the controller is in the provider class
            prefixIcon: "assets/ui/addservice/date.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            suffixIcon: IconButton(
              onPressed: () => _selectDate(context),
              icon: Icon(Icons.date_range),
            ),
            hint_text: "date".tr().toString(),
            FunctionToDo: () {
              print("Hello");
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: colorApp.timePickerBorder,
            controller_text: timeController, // the controller is in the provider class
            prefixIcon: "assets/ui/addservice/time.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            suffixIcon: IconButton(
              onPressed: () => _selectTime(context),
              icon: Icon(Icons.date_range),
            ),
            hint_text: "time".tr().toString(),
            FunctionToDo: () {
              print("Hello");
            },
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),

          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: colorApp.timePickerBorder,
            controller_text:
                mapProvider.searchPageFromController, // the controller is in the provider class
            prefixIcon: "assets/ui/addservice/add_service.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            suffixIcon: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MapPickerSearchFrom.id);
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
          // TextInputFieldWithIconRoundedCorners(
          //   controller_text: toController,
          //   prefixIcon: "assets/ui/addservice/add_service.png",
          //   show_password: false,
          //   //  icon_widget: Icon(Icons.location_on),
          //   hint_text: "to".tr().toString(),
          //   FunctionToDo: () {
          //     print("Hello");
          //   },
          // ),
          TextInputFieldWithIconRoundedCorners(
            prefixIconColor: colorApp.timePickerBorder,
            controller_text:
                mapProvider.searchPageToController, // the controller is in the provider class
            prefixIcon: "assets/ui/addservice/add_service.png",
            show_password: false,
            //  icon_widget: Icon(Icons.location_on),
            suffixIcon: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(MapPickerSearchTo.id);
              },
              icon: Icon(Icons.share_location),
            ),
            hint_text: "to".tr().toString(),
            FunctionToDo: () {
              // print("Hello");
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Button(
            colour: colorApp.buttonColor,
            textColor: Colors.black,
            onPressed: sendRequest,
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

  //-Widget Tree


}
//done


 */

//-> Widget Tree
  Widget toggleButtonServiceType() {
    return ToggleButtons(
      borderWidth: 0,
      renderBorder: false,
      // to delete the border around the toggle buttons
      selectedColor: colorApp.selectedColor,
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0; buttonIndex < isSelectedServiceType.length; buttonIndex++) {
            if (buttonIndex == index) {
              // we get 1
              serviceType = 2; //seeked service
              isSelectedServiceType[buttonIndex] = true;
            } else {
              // we get zero
              serviceType = 1; // provided service
              isSelectedServiceType[buttonIndex] = false;
            }
          }
        });
      },
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/ui/search/provided_service.png"),
                    ),
                  ),
                ),
                Text(
                  "provided".tr().toString(),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
              child: Column(
            children: [
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/ui/search/seeked_service.png"),
                  ),
                ),
              ),
              Text(
                "seeked".tr().toString(),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )
            ],
          )),
        ),
      ],
      isSelected: isSelectedServiceType,
    );
  } // end widget service type

//-> Widget Tree
  Widget toggleButtonGenderType() {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(50),
      fillColor: Colors.transparent, // to delete the blue color around the selection
      borderWidth: 2,
      renderBorder: true, // to delete the border around the toggle buttons
      selectedColor: colorApp.selectedColor,
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0; buttonIndex < isSelectedGenderType.length; buttonIndex++) {
            if (buttonIndex == index) {
              // we get 1
              isSelectedGenderType[buttonIndex] = true;
              genderType = "Female";
              changeColor = true;
            } else {
              // we get zero
              isSelectedGenderType[buttonIndex] = false;
              genderType = "Male";
              changeColor = false;
            }
          }
        });
      },
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            child: Column(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // to make the selection circular
                    color: (!changeColor) ? colorApp.selectedColor : Colors.white,
                    image: DecorationImage(
                      image: AssetImage("assets/ui/search/male.png"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
              child: Column(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), // to make the selection circular
                  color: (changeColor) ? colorApp.selectedColor : Colors.white,
                  image: DecorationImage(
                    image: AssetImage("assets/ui/search/female.png"),
                  ),
                ),
              ),
            ],
          )),
        ),
      ],
      isSelected: isSelectedGenderType,
    );
  } // end widget gender type

  Widget toggleButtonCarryType() {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(50),
      fillColor: Colors.transparent, // to delete the blue color around the selection
      borderWidth: 2,
      renderBorder: true, // to delete the border around the toggle buttons
      selectedColor: colorApp.selectedColor,
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0; buttonIndex < isSelectedCarryType.length; buttonIndex++) {
            if (buttonIndex == index) {
              // we get 1
              isSelectedCarryType[buttonIndex] = true;
              carryType = "Package";
              changeColor2 = true;
            } else {
              // we get zero
              isSelectedCarryType[buttonIndex] = false;
              carryType = "Person";
              changeColor2 = false;
            }
          }
          print(carryType);
        });
      },
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            child: Column(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // to make the selection circular
                    color: (!changeColor2) ? colorApp.selectedColor : Colors.white,
                    image: DecorationImage(
                      image: AssetImage("assets/ui/search/person.png"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
              child: Column(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), // to make the selection circular
                  color: (changeColor2) ? colorApp.selectedColor : Colors.white,
                  image: DecorationImage(
                    image: AssetImage("assets/ui/search/package.png"),
                  ),
                ),
              ),
            ],
          )),
        ),
      ],
      isSelected: isSelectedCarryType,
    );
  } // end widget gender type

//-> public or private

  Widget toggleButtonPrivacyType() {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(50),
      fillColor: Colors.transparent, // to delete the blue color around the selection
      borderWidth: 2,
      renderBorder: true, // to delete the border around the toggle buttons
      selectedColor: colorApp.selectedColor,
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0; buttonIndex < isSelectedPrivacyType.length; buttonIndex++) {
            if (buttonIndex == index) {
              // we get 1
              isSelectedPrivacyType[buttonIndex] = true;
              privacyType = "Public";
              changeColor3 = true;
            } else {
              // we get zero
              isSelectedPrivacyType[buttonIndex] = false;
              privacyType = "Private";
              changeColor3 = false;
            }
          }
          print(privacyType);
        });
      },
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
            child: Column(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), // to make the selection circular
                    color: (!changeColor3) ? colorApp.selectedColor : Colors.white,
                    image: DecorationImage(
                      image: AssetImage("assets/ui/search/private.png"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: InkWell(
              child: Column(
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), // to make the selection circular
                  color: (changeColor3) ? colorApp.selectedColor : Colors.white,
                  image: DecorationImage(
                    image: AssetImage("assets/ui/search/public.png"),
                  ),
                ),
              ),
            ],
          )),
        ),
      ],
      isSelected: isSelectedPrivacyType,
    );
  } // end widget gender type

  Widget dateTimePicker() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(right: 10, left: 10),
      child: DateTimePicker(
        // initialEntryMode: DatePickerEntryMode.input,
        decoration: InputDecoration(border: InputBorder.none),
        use24HourFormat: false,
        type: DateTimePickerType.dateTimeSeparate,
        style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        dateMask: 'd /M/ yyyy',
        initialValue: "_",
        // initialValue: DateTime.now().toString(),

        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        icon: Icon(
          Icons.event,
          color: Colors.white,
        ),
        dateLabelText: 'date'.tr().toString(),
        timeLabelText: 'hour'.tr().toString(),

        onChanged: (val) {
          if (val.isNotEmpty) {
            setState(() {
              datetobesend = val;
            });
          }
        },

        onSaved: (val) {
          if (val.isNotEmpty) {
            setState(() {
              datetobesend = val;
            });
          }
        }, // pass data to the function
      ),
    );
  }
} // end class
