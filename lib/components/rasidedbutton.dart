import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RasiedButton extends StatelessWidget {
  final String labeltext;
  final Function FunctionToDO;

  RasiedButton({@required this.labeltext, this.FunctionToDO});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 55.0, left: 55.0),
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Color(0xFF8949d8),
        child: Text(
          labeltext.tr().toString(),
          style: TextStyle(fontSize: 20.0.sp, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(
            color: Colors.blueAccent,
          ),
        ),
        onPressed: FunctionToDO,
      ),
    );
  }
} // end class
