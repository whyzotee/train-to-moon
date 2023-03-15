import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class UserPosition extends ChangeNotifier {
  bool showL = false;
  bool showR = false;

  void setUserPos(bool joinL, bool joinR) {
    if (joinL) {
      showL = true;
    }

    if (joinR) {
      showR = true;
    }
    notifyListeners();
  }
}
