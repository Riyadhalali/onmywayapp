import 'package:flutter/material.dart';

class Global extends ChangeNotifier {
  bool showProgressInMap = false;

  void showProgress(bool value) {
    showProgressInMap = value;
    notifyListeners();
  }
}
