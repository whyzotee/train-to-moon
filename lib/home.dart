import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'room.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _roomID = TextEditingController();

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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter number of room';
                        }
                        return null;
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomPage(
                          roomID: int.parse(_roomID.text),
                        ),
                      ),
                    );
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
