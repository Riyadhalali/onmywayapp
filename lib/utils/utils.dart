import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  void snackMessage(BuildContext context, String message) {}

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }

//-> show processing dialog
  void showProcessingDialog(String text, BuildContext context) async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            content: Container(
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 25.0,
                ),
                Text(text, style: TextStyle(fontFamily: "OpenSans", color: Color(0xFF5B6978)))
              ]),
            ),
          );
        });
  }
}
