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
  String dropDownMenuGender =
      ""; // very important or we will get a null message when fetching api services

  String dropDownMenuType = "";

  //-> this method to get selected time from datetimepicker statfull widget
  void getdatetime() {
    print(DateTimePickerClass.valueselected);
  }

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
        new DropdownButton<String>(
          value: "person".tr().toString(),
          items: <String>[
            'person'.tr().toString(),
            'package'.tr().toString(),
          ].map((String value) {
            return new DropdownMenuItem<String>(
              value: value,
              child: new Text(
                value,
                style: TextStyle(fontSize: 15.0.sp),
              ),
            );
          }).toList(),
          onChanged: (String value2) {
            setState(() {
              dropDownMenuType = value2;
            });
          },
        )
      ],
    );
  }

//------------------------------------------------------------------------------
} //end class
