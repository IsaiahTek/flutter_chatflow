import 'package:flutter/material.dart';
import 'package:flutter_chatflow/chatflow.dart';
import 'package:flutter_chatflow/widgets/audio_message.dart';
import 'package:flutter_chatflow/widgets/image_message.dart';
import 'package:flutter_chatflow/widgets/video_message.dart';

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
        VideoMessage videoMessage = message as VideoMessage;
        result = VideoMessageWidget(uri: videoMessage.uri, text: videoMessage.text,);
        break;
      case MessageType.audio:
        AudioMessage audioMessage = message as AudioMessage;
        result = AudioMessageWidget(uri: audioMessage.uri, text: audioMessage.text,);
      default:
        TextMessage textMessage = message as TextMessage;
        result = Text(textMessage.text);
    }
    return result;
  }
}