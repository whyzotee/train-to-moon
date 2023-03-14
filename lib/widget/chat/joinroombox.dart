import 'package:flutter/material.dart';

class JoinRoomBox extends StatefulWidget {
  final List allMessage;
  final int index;

  const JoinRoomBox({super.key, required this.allMessage, required this.index});

  @override
  State<JoinRoomBox> createState() => _JoinRoomBoxState();
}

class _JoinRoomBoxState extends State<JoinRoomBox> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF505050),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'ยินดีต้อนรับคุณ ${widget.allMessage[widget.index]["join"]} เข้าสู่ห้อง',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
