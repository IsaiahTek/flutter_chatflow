import 'package:flutter/material.dart';
import 'package:flutter_chatflow/chatflow.dart';
import 'package:flutter_chatflow/widgets/image_message.dart';

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
      case MessageType.video:
        
      default:
        TextMessage textMessage = message as TextMessage;
        result = Text(textMessage.text);
    }
    return result;
  }
}