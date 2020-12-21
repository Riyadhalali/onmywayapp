import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

//-> this page for adding or sekking service so i am a customer or provider
class AddSeekService extends StatefulWidget {
  static const id = 'addSeekService';
  @override
  _AddSeekServiceState createState() => _AddSeekServiceState();
}

class _AddSeekServiceState extends State<AddSeekService> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: DateTimePicker(
          type: DateTimePickerType.dateTimeSeparate,
          dateMask: 'd MMM, yyyy',

          initialValue: DateTime.now().toString(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          icon: Icon(Icons.event),
          dateLabelText: 'Date',
          timeLabelText: "Hour",
          selectableDayPredicate: (date) {
            // Disable weekend days to select from the calendar
            if (date.weekday == 6 || date.weekday == 7) {
              return false;
            }

            return true;
          },
          onChanged: (val) => print(val),
          validator: (val) {
            print(val);
            return null;
          },
          onSaved: (val) => print(val), // print when user hit ok
        ),
      ),
    );
  }
}
