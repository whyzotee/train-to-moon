import 'dart:math' as math;

import 'package:flutter/material.dart';

class UserPosition extends ChangeNotifier {
  bool showL = false;
  bool showR = false;

  void setUserPos(bool joinL, bool joinR) {
    showL = joinL;
    showR = joinR;

    notifyListeners();
  }

  Widget showUserLeft(context) {
    return Positioned(
      left: MediaQuery.of(context).size.height * 0.20,
      bottom: MediaQuery.of(context).size.height * 0.13,
      child: Image(
        image: const AssetImage('assets/images/user.png'),
        height: MediaQuery.of(context).size.height * 0.15,
      ),
    );
  }

  Widget showUserRight(context) {
    return Positioned(
      right: MediaQuery.of(context).size.height * 0.15,
      bottom: MediaQuery.of(context).size.height * 0.13,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: Image(
          image: const AssetImage(
            'assets/images/user.png',
          ),
          height: MediaQuery.of(context).size.height * 0.15,
        ),
      ),
    );
  }
}
