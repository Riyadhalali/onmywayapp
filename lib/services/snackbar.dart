import 'package:flutter/material.dart';

class snackbarMessage {
  BuildContext context;
  String message;
/*  snackbarMessage(context, message) {
    this.context = context;
    this.message = message;
  }*/

  displaySnackBar(context, message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
} // end class
