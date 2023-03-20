import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.sender});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Colors.green,
            radius: 30,
            child: Text(
              sender[0],
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sender,
                style: TextStyle(fontSize: 20),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
