import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    super.key,
    required this.text,
    required this.sender,
    this.isImage = false,
  });

  final String text;
  final String sender;
  final bool isImage;

  bool isBot(String sender) {
    if (sender == "Bot") {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sender)
            .text
            .subtitle2(context)
            .make()
            .box
            .color(sender == "Bot" ? Colors.blue : Colors.green)
            .p12
            .rounded
            .alignCenter
            .makeCentered(),
        Expanded(
            child: isImage
                ? AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      text,
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : const LinearProgressIndicator(),
                    ),
                  )
                : text.trim().text.bodyText1(context).make().px8()),
      ],
    ).py8();
  }
}
