import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'room.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _joinFormKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final _roomID = TextEditingController();
  final _userName = TextEditingController();

  static const _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';

  String randomStr(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(Random().nextInt(_chars.length)),
      ),
    );
  }

  Future fetchRoomData(String roomID) async {
    String url =
        'https://3411-2001-fb1-10c-c12e-85f2-6bb1-72d7-c057.ap.ngrok.io/msg/$roomID';
    await http.get(Uri.parse(url)).then((res) {
      if (res.statusCode == 200) {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(
              roomID: roomID,
              userName: _userName.text,
            ),
          ),
        );
      } else {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('เกิดข้อผิดพลาด'),
              content: res.statusCode == 404
                  ? const Text('ไม่พบห้อง')
                  : const Text('ห้องเต็ม'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Okay!'),
                )
              ],
            );
          },
        );
      }
    });
  }

  Future fetchCreateRoom(String roomID) async {
    String url =
        'https://3411-2001-fb1-10c-c12e-85f2-6bb1-72d7-c057.ap.ngrok.io/msg/new/$roomID';
    await http.get(Uri.parse(url)).then((res) {
      if (res.statusCode == 200) {
        var room = jsonDecode(res.body);

        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(
              roomID: room[Random().nextInt(room.length)],
              userName: _userName.text,
            ),
          ),
        );
      } else if (res.statusCode == 201) {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(
              roomID: roomID,
              userName: _userName.text,
            ),
          ),
        );
      } else {
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
                key: _formKey,
                child: TextFormField(
                  controller: _userName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Type Your Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter yourname';
                    }
                    return null;
                  },
                )),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  return await fetchCreateRoom(randomStr(7));
                }
              },
              child: const Text('สุ่มเจอเพื่อนใหม่'),
            ),
            const SizedBox(height: 50),
            const Text('หรือ ใส่เลขห้องเพื่อเข้าร่วมห้องกับเพื่อนของคุณ'),
            const SizedBox(height: 50),
            Row(
              children: <Widget>[
                Flexible(
                  child: Form(
                    key: _joinFormKey,
                    child: TextFormField(
                      controller: _roomID,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Type Room Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter Room Name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_joinFormKey.currentState!.validate()) {
                        return await fetchRoomData(_roomID.text);
                      }
                    }
                  },
                  child: const Text('Join'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
