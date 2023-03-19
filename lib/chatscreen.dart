import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override

  Widget _buildTextComposer()

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const <Widget>[
            Icon(Icons.assistant),
            Text("FBOT"),
          ],
        ),
        titleTextStyle: const TextStyle(
          color: Colors.green,
          fontSize: 20,
        ),
      ),
      body: Column(
        children: const [
          Container(
            decoration: BoxDecoration(color: Colors.blue),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
