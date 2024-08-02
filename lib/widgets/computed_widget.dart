part of '../library.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chatflow/models.dart';
// import 'package:flutter_chatflow/utils/type_defs.dart';
// import 'package:flutter_chatflow/utils/types.dart';
// import 'package:flutter_chatflow/widgets/audio/audio_message.dart';
// import 'package:flutter_chatflow/widgets/image/image_message.dart';
// import 'package:flutter_chatflow/widgets/video/video_message.dart';

/// Class to dynamically chose which widget to use to display a particular message based on message type
class ComputedMessage extends StatelessWidget {
  /// Message
  final Message message;

  /// If true, message is displayed to the right
  final bool isAuthor;

  /// Optional widget to be passed
  final CustomWidgetBuilder? customWidgetBuilder;

  /// Optional widget to be passed
  final CustomWidgetBuilder? videoWidgetBuilder;

  /// Optional widget to be passed
  final CustomWidgetBuilder? pdfWidgetBuilder;

  /// [Optional] If false or not provide the text will be displayed under the image.
  /// Otherwise, the text will not be displayed.
  final bool? shouldHideText;

  /// [Optional] Internally used to scale image to fit available box
  final bool? shouldFitToAvailableSize;

  /// Handle the computation
  const ComputedMessage(
      {super.key,
      required this.message,
      required this.isAuthor,
      this.customWidgetBuilder,
      this.videoWidgetBuilder,
      this.pdfWidgetBuilder,
      this.shouldHideText,
      this.shouldFitToAvailableSize});

  @override
  Widget build(BuildContext context) {
    Widget result;
    switch (message.type) {
      case MessageType.image:
        ImageMessage imageMessage = message as ImageMessage;
        result = ImageMessageWidget(
          uri: imageMessage.uri,
          text: imageMessage.text,
          isAuthor: isAuthor,
          shouldHideText: shouldHideText,
          shouldFitToAvailableSize: shouldFitToAvailableSize,
        );
        break;
      case MessageType.video:
        if (videoWidgetBuilder != null) {
          VideoMessage videoMessage = message as VideoMessage;
          result = VideoMessageWidget(
            uri: videoMessage.uri,
            text: videoMessage.text,
            isAuthor: isAuthor,
            videoWidgetBuilder: videoWidgetBuilder!,
            shouldHideText: shouldHideText,
            shouldFitToAvailableSize: shouldFitToAvailableSize,
          );
        } else {
          result = const SizedBox();
        }
        break;
      case MessageType.audio:
        AudioMessage audioMessage = message as AudioMessage;
        result = AudioMessageWidget(
            uri: audioMessage.uri, text: audioMessage.text, isAuthor: isAuthor);
      default:
        TextMessage textMessage = message as TextMessage;
        result = Text(textMessage.text);
    }
    return result;
  }
}
