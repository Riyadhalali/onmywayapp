import 'package:alatareekeh/components/dropdownmenu.dart';
import 'package:alatareekeh/components/rasidedbutton.dart';
import 'package:alatareekeh/components/textfield.dart';
import 'package:alatareekeh/components/timedatepicker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

//-> this page for adding or sekking service so i am a customer or provider
class AddSeekService extends StatefulWidget {
  static const id = 'addSeekService';
  @override
  _AddSeekServiceState createState() => _AddSeekServiceState();
}

class _AddSeekServiceState extends State<AddSeekService> {
  String dropDownMenu =
      ""; // very important or we will get a null message when fetching api services
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'From',
              show_password: false,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'To',
              show_password: false,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            DateTimePickerClass(),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'Status',
              show_password: false,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            DropDownMenuWidget(),
            SizedBox(
              height: 2.0.h,
            ),
            DropDownMenuWidget(),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'Space',
              show_password: false,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            TextInputField(
              hint_text: 'Phone ',
              show_password: false,
            ),
            SizedBox(
              height: 2.0.h,
            ),
            RasiedButton(),
          ],
        ),
      ],
    );
  }
  //----------------------------------------------------------------------------
} //end class
//TODO: 1- get the data from dropdown menu and datetimepicker
//TODO : 2 -try to resize text input field and change the model
//TODO: 3- i must save login id in shared pref
//TODO: 4- work with rasied button class and drop down menu and time picker
