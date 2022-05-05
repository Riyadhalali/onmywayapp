import 'package:alatareekeh/constants/colors.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateTimePickerClass extends StatefulWidget {
  static String valueselected = null; // to access this variable from another class

  // static DateTime now = DateTime.now();
  // static String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

  @override
  _DateTimePickerClassState createState() => _DateTimePickerClassState();
}

class _DateTimePickerClassState extends State<DateTimePickerClass> {
  //---------------------Function to round time--------------------------------
  ColorsApp colorsApp = new ColorsApp();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: colorsApp.timePickerBorder,
          ),
          padding: EdgeInsets.only(right: 55, left: 55),
          child: DateTimePicker(
            type: DateTimePickerType.dateTimeSeparate,
            style: TextStyle(color: Colors.white),
            dateMask: 'd MMM, yyyy',
            // initialValue: DateTime.now().toString(),
            initialValue: DateTime.now().toString(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),

            icon: Icon(
              Icons.event,
              color: Colors.white,
            ),
            dateLabelText: 'date'.tr().toString(),
            timeLabelText: 'hour'.tr().toString(),
            selectableDayPredicate: (date) {
              // Disable weekend days to select from the calendar
              // if (date.weekday == 6 || date.weekday == 7) {
              //   return false;
              // }
              return true;
            },
            onChanged: (val) => {DateTimePickerClass.valueselected = val},
            // to set the variable and be accessed from another classes
            validator: (val) {
              print(val);
              return null;
            },
            onSaved: (val) => {
              DateTimePickerClass.valueselected = val
              // to set the variable and be accessed from another classes
            }, // pass data to the function
          ),
        ),
      ),
    );
  }
//------------------------------------------------------------------------------
} // end class
