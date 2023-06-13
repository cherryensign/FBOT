import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:fbot/threedots.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'chatmessage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> _messages = [ChatMessage(text: "Hello!!!", sender: "Bot")];

  late OpenAI? chatGPT;
  bool _isTyping = false;
  bool _isImageSearched = false;

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
        token: "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",
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 20),
            connectTimeout: const Duration(seconds: 20)),
        isLog: true);
    super.initState();
  }

  @override
  //void dispose() {
  //  chatGPT?.close();
  //  chatGPT?.genImgClose();
  //  super.dispose();
  //}

  void insertNewData(String response, {bool isImage = false}) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "Bot",
      isImage: isImage,
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "User",
      isImage: false,
    );
    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });
    _controller.clear();

    if (_isImageSearched) {
      final request = GenerateImage(message.text, 1,
          size: ImageSize.size256, responseFormat: Format.url);

      final response =
          chatGPT!.generateImage(request).asStream().listen((event) {
        Vx.log(event?.data!.last!.url!);
        insertNewData(event!.data!.last!.url!, isImage: true);
      });
    } else {
      final request = CompleteText(
        prompt: message.text,
        model: Model.textDavinci3,
      );
      final response =
          chatGPT!.onCompletion(request: request).asStream().listen((event) {
        Vx.log(event?.choices[0].text);
        insertNewData(event!.choices[0].text, isImage: false);
      });
    }
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
              onPressed: () {
                _isImageSearched = false;
                _sendMessage();
              },
              icon: const Icon(
                Icons.send,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () {
                _isImageSearched = true;
                _sendMessage();
              },
              icon: const Icon(
                Icons.image_search,
                color: Colors.blue,
              ),
            ),
            IconButton(
                onPressed: _clearMessages,
                icon: const Icon(
                  Icons.clear_all,
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
          padding: const EdgeInsets.all(5),
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
                left: 10,
                right: 10,
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
