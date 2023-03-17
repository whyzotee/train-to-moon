import 'dart:math' as math;

import 'package:flutter/material.dart';

class UserPosition extends ChangeNotifier {
  bool showL = false;
  bool showR = false;

  String? userL;
  String? userR;

  void setUserPos(String? joinL, String? joinR) {
    showL = joinL != null;
    showR = joinR != null;

    userL = joinL;
    userR = joinR;

    notifyListeners();
  }

  Widget showUserLeft(context) {
    return Positioned(
      left: MediaQuery.of(context).size.height * 0.20,
      bottom: MediaQuery.of(context).size.height * 0.13,
      child: Stack(children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            userL!,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        Image(
          image: const AssetImage('assets/images/user.png'),
          height: MediaQuery.of(context).size.height * 0.15,
        ),
      ]),
    );
  }

  Widget showUserRight(context) {
    return Positioned(
      right: MediaQuery.of(context).size.height * 0.15,
      bottom: MediaQuery.of(context).size.height * 0.13,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                userR!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Image(
              image: const AssetImage(
                'assets/images/user.png',
              ),
              height: MediaQuery.of(context).size.height * 0.15,
            ),
          ),
        ],
      ),
    );
  }
}
