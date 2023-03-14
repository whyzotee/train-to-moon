import 'package:flutter/material.dart';

class MessageBox extends StatefulWidget {
  final bool isSender;
  final String name;
  final String msg;
  final String time;

  const MessageBox({
    super.key,
    required this.isSender,
    required this.name,
    required this.msg,
    required this.time,
  });

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            alignment:
                widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
            padding: EdgeInsets.only(
              bottom: 5,
              left: widget.isSender ? 0 : 10,
              right: widget.isSender ? 10 : 0,
            ),
            child: Text(widget.name),
          ),
          Container(
            padding: EdgeInsets.only(
              left: widget.isSender ? 0 : 10,
              right: widget.isSender ? 10 : 0,
            ),
            alignment:
                widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF505050),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                widget.msg,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            alignment:
                widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
            padding: EdgeInsets.only(
              top: 10,
              left: widget.isSender ? 0 : 10,
              right: widget.isSender ? 10 : 0,
            ),
            child: Text(widget.time),
          ),
        ],
      ),
    );
  }
}
