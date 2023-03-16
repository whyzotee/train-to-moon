import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traintomoon/provider/chat-store.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'widget/chat/messagebox.dart';

class ChatRoomPage extends StatefulWidget {
  final String roomID;
  final String userName;

  const ChatRoomPage({
    super.key,
    required this.roomID,
    required this.userName,
  });

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _controller = TextEditingController();

  final String domain = '127.0.0.1';
  final int port = 4399;

  late final String userName = widget.userName;
  late final String roomID = widget.roomID;

  late String serverUrl = 'ws://$domain:$port/msg/ch@$roomID!name=$userName';

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
              Stack(
                children: [
                  Image(
                    image: const AssetImage('assets/images/train.png'),
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  Consumer(
                    builder: (
                      BuildContext context,
                      UserPosition value,
                      Widget? child,
                    ) {
                      if (value.showL) {
                        return value.showUserLeft(context);
                      } else {
                        return Container();
                      }
                    },
                  ),
                  Consumer(
                    builder: (
                      BuildContext context,
                      UserPosition value,
                      Widget? child,
                    ) {
                      if (value.showR) {
                        return value.showUserRight(context);
                      } else {
                        return Container();
                      }
                    },
                  )
                ],
              ),
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
    var provider = context.read<UserPosition>();
    return StreamBuilder(
      stream: _channel.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData && userID == null) {
          var userData = jsonDecode(snapshot.data);
          userID = userData["id"];

          if (userID != null) {
            _channel.sink.add(
              jsonEncode({
                "join": widget.userName,
                "uuid": userID,
                "pos": userData["pos"],
              }),
            );
          } else {
            _channel.sink.add({
              jsonEncode({"error": "[ws-server] Error: โปรดติดต่อผู้พัฒนา"})
            });
          }
        }

        if (snapshot.hasData) {
          print(snapshot.data);
          var temp = jsonDecode(snapshot.data);
          if (temp["pos"] != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.setUserPos(temp["pos"]["L"], temp["pos"]["R"]);
            });
          }

          roomMessage.add(temp);

          return Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: roomMessage.length,
              itemBuilder: (BuildContext context, int index) {
                if (roomMessage[index]["id"] != null) {
                  return Container();
                } else if (roomMessage[index]["join"] != null) {
                  return Text('${roomMessage[index]["join"]} เข้าร่วมห้อง');
                } else if (roomMessage[index]["leave"] != null) {
                  return Text('${roomMessage[index]["leave"]} ออกห้อง');
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
          return Expanded(child: Container());
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
