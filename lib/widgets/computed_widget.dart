import 'package:flutter/material.dart';
import 'package:fluchat/chat.dart';
import 'package:fluchat/widgets/image_message.dart';

class ComputedMessage extends StatelessWidget{
  
  final Message message;
  
  const ComputedMessage({
    super.key,
    required this.message
  });
  
  @override
  Widget build(BuildContext context) {
    Widget result;
    switch (message.type) {
      case MessageType.image:
        ImageMessage imageMessage = message as ImageMessage;
        result = ImageMessageWidget(uri: imageMessage.uri, text: imageMessage.text,);
        break;
      default:
        TextMessage textMessage = message as TextMessage;
        result = Text(textMessage.text);
    }
    return result;
  }
}