import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration.collapsed(hintText: "Type here..."),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Row(
            children: const <Widget>[
              Icon(Icons.assistant),
              SizedBox(
                width: 20,
              ),
              Text("FBOT"),
            ],
          ),
        ),
        titleTextStyle: const TextStyle(
          color: Colors.green,
          fontSize: 30,
        ),
      ),
      body: Column(
        children: [
          Container(
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
