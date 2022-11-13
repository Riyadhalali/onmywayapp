import 'package:alatareekeh/constants/colors.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/mapProvider.dart';

class DateTimePickerClass extends StatefulWidget {
  static String valueselected;
  Color backgroundColor;
  Color textColor;

  DateTimePickerClass({this.backgroundColor, this.textColor});

  static DateTime now = DateTime.now();
  //static String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
  // String get initialValue {
  //   return initialValue;
  // }

  @override
  _DateTimePickerClassState createState() => _DateTimePickerClassState();
}

class _DateTimePickerClassState extends State<DateTimePickerClass> {
  //---------------------Function to round time--------------------------------
  ColorsApp colorsApp = new ColorsApp();
  @override
  Widget build(BuildContext context) {
    MapProvider mapProvider = Provider.of<MapProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: widget.backgroundColor,
      ),
      padding: EdgeInsets.only(right: 10, left: 10),
      child: DateTimePicker(
        // initialEntryMode: DatePickerEntryMode.input,
        decoration: InputDecoration(border: InputBorder.none),
        use24HourFormat: false,
        type: DateTimePickerType.dateTimeSeparate,
        style: TextStyle(color: widget.textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
        dateMask: 'd /M/ yyyy',
        initialValue: "_",
        //  initialValue: DateTime.now().toString(),

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
        onChanged: (val) => {
          // DateTimePickerClass.valueselected = val
          mapProvider.serviceTimeProvidedService(val)
        },
        // to set the variable and be accessed from another classes
        // validator: (val) {
        //   if (val != null) {
        //     return null;
        //   } else {
        //     return 'Date Field is Empty';
        //   }
        // },
        onSaved: (val) => {
          // DateTimePickerClass.valueselected = val
          mapProvider.serviceTimeProvidedService(val)
          // to set the variable and be accessed from another classes
        }, // pass data to the function
      ),
    );
  }
//------------------------------------------------------------------------------
} // end class
