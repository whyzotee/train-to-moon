import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'room.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _roomID = TextEditingController();
  final _userName = TextEditingController();

  Future fetchRoomData(String roomID) async {
    String url = 'http://127.0.0.1:4399/msg/$roomID';
    await http.get(Uri.parse(url)).then((res) {
      if (res.statusCode == 200) {
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomPage(
              roomID: int.parse(_roomID.text),
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
              title: const Text('Error!'),
              content: const Text('ห้องเต็ม'),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text('Okay!'),
                )
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _roomID,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Type Room Number',
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
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
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    return await fetchRoomData(_roomID.text);
                  }
                },
                child: const Text('go'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
