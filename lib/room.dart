import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'widget/chat/messagebox.dart';
import 'widget/chat/joinroombox.dart';

class ChatRoomPage extends StatefulWidget {
  final int roomID;
  final String userName;

  const ChatRoomPage({super.key, required this.roomID, required this.userName});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _controller = TextEditingController();

  final String domain = '127.0.0.1';
  final int port = 4399;
  late String serverUrl = 'ws://$domain:$port/msg/channel@${widget.roomID}';
  late final _channel = WebSocketChannel.connect(Uri.parse(serverUrl));

  String? userID;
  List<Map> roomMessage = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Room : ${widget.roomID}',
                  style: const TextStyle(
                    color: Color(0xFF505050),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              chatScreen(),
              const SizedBox(height: 24),
              Form(
                child: TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Type Some thing',
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _sendMessage,
          tooltip: 'Send message',
          child: const Icon(Icons.send),
        ),
      ),
    );
  }

  Widget chatScreen() {
    return StreamBuilder(
      stream: _channel.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && userID == null) {
          var status = jsonDecode(snapshot.data);
          if (!status["status"]) {
            return const Text('[ws-server] Error: โปรดติดต่อผู้พัฒนา');
          }

          userID = status["id"];

          if (userID != null) {
            _channel.sink.add(
              jsonEncode({
                "join": widget.userName,
                "uuid": userID,
              }),
            );
          } else {
            _channel.sink.add('[ws-server] Error: โปรดติดต่อผู้พัฒนา');
          }
        }

        if (snapshot.hasData) {
          var temp = jsonDecode(snapshot.data);
          roomMessage.add(temp);

          return Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: roomMessage.length,
              itemBuilder: (BuildContext context, int index) {
                if (roomMessage[index]["id"] != null) {
                  return Container();
                } else if (roomMessage[index]["join"] != null) {
                  return JoinRoomBox(allMessage: roomMessage, index: index);
                } else {
                  return MessageBox(
                    isSender: roomMessage[index]["uuid"] == userID,
                    name: roomMessage[index]["name"],
                    msg: roomMessage[index]["message"],
                    time: roomMessage[index]["time"],
                  );
                }
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty && userID != null) {
      String userText = jsonEncode({
        "uuid": userID,
        "name": widget.userName,
        "message": _controller.text,
        "time": DateTime.now().toString(),
      });

      _channel.sink.add(userText);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
