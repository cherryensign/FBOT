import 'dart:async';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:fbot/threedots.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'chatmessage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> _messages = [ChatMessage(text: "Hello!!!", sender: "Bot")];

  final chatGPT = OpenAI.instance;
  StreamSubscription? _subscription;
  bool _isTyping = false;

  void _sendMessage() {
    ChatMessage message = ChatMessage(text: _controller.text, sender: "User");
    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });
    _controller.clear();

    final request = CompleteText(
      prompt: message.text,
      model: kTranslateModelV3,
      maxTokens: 200,
    );
    Vx.log(message.text);
    _subscription = chatGPT
        .build(
          token: "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",
        )
        .onCompleteStream(request: request)
        .listen((response) {
      Vx.log(response!.choices[0].text);
      ChatMessage botMessage = ChatMessage(
        text: response.choices[0].text,
        sender: "Bot",
      );

      setState(() {
        _isTyping = false;
        _messages.insert(0, botMessage);
      });
    });
  }

  void _clearMessages() {
    setState(() {
      _messages = [];
    });
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Container(
        height: 100,
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(fontSize: 20),
                controller: _controller,
                onSubmitted: (value) => _sendMessage(),
                decoration:
                    const InputDecoration.collapsed(hintText: "Type here..."),
              ),
            ),
            IconButton(
              onPressed: _sendMessage,
              icon: const Icon(
                Icons.send,
                color: Colors.blue,
              ),
            ),
            IconButton(
                onPressed: _clearMessages,
                icon: const Icon(
                  Icons.clear,
                  color: Colors.blue,
                )),
          ],
        ),
      ),
    );
  }

  @override
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
          color: Colors.blue,
          fontSize: 30,
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          if (_isTyping) const ThreeDots(),
          const Divider(
            height: 1,
          ),
          Container(
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}
