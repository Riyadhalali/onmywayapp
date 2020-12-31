import 'package:alatareekeh/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AddAppointment extends StatefulWidget {
  static const id = 'add_appointment';
  @override
  _AddAppointmentState createState() => _AddAppointmentState();
}

class _AddAppointmentState extends State<AddAppointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColumnElements(),
    );
  } // end build

//--------------------------Column Elements---------------------------------
  Widget ColumnElements() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AddAppointmetWidget(),
          ],
        ),
      ),
    );
  }

  //--------------------------Add Appointment---------------------------------
  Widget AddAppointmetWidget() {
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
              //controller_text: _usernameController,
            ),
          ],
        ),
      ],
    );
  }
//--------------------------------------------------------------------------

}
