import 'package:flutter/material.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/widgets/video/video_widget.dart';

/// Video Message Widget. You are to implement this and pass in the builder for ChatFlow to use
class VideoMessageWidget extends StatelessWidget {
  /// uri/url or local file path
  final String uri;

  /// [Optional] text to be displayed with the video
  final String? text;

  /// If set to true, the widget is displayed to the right.
  final bool? isAuthor;

  /// Create the widget and pass in for ChatFlow to use
  final VideoWidgetBuilder videoWidgetBuilder;

  /// Video Message Widget
  const VideoMessageWidget(
      {super.key,
      required this.uri,
      required this.videoWidgetBuilder,
      this.text,
      this.isAuthor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: VideoWidget(
            uri: uri,
            videoWidgetBuilder: videoWidgetBuilder,
          ),
        ),
        if (text != null && text!.isNotEmpty) Text(text!)
      ],
    ));
  }
}
