import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/widgets/audio/audio_message.dart';
import 'package:flutter_chatflow/widgets/image/image_message.dart';
import 'package:flutter_chatflow/widgets/video/video_message.dart';

class ComputedMessage extends StatelessWidget{
  
  final Message message;

  final bool isAuthor;
  
  const ComputedMessage({
    super.key,
    required this.message,
    required this.isAuthor,
  });
  
  @override
  Widget build(BuildContext context) {
    Widget result;
    switch (message.type) {
      case MessageType.image:
        ImageMessage imageMessage = message as ImageMessage;
        result = ImageMessageWidget(uri: imageMessage.uri, text: imageMessage.text, isAuthor: isAuthor,);
        break;
      case MessageType.video:
        VideoMessage videoMessage = message as VideoMessage;
        result = VideoMessageWidget(uri: videoMessage.uri, text: videoMessage.text, isAuthor: isAuthor);
        break;
      case MessageType.audio:
        AudioMessage audioMessage = message as AudioMessage;
        result = AudioMessageWidget(uri: audioMessage.uri, text: audioMessage.text, isAuthor: isAuthor);
      default:
        TextMessage textMessage = message as TextMessage;
        result = Text(textMessage.text);
    }
    return result;
  }
}