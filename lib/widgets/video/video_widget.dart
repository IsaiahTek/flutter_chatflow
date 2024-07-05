import 'package:flutter/material.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';

/// Video Widget. You are to implement this and pass in the builder for ChatFlow to use
class VideoWidget extends StatelessWidget {
  /// uri/url or local file path
  final String uri;

  /// [Optional] text to be displayed with the video
  final VideoWidgetBuilder videoWidgetBuilder;

  /// Pass in the builder for ChatFlow to use to display the widget
  const VideoWidget(
      {super.key, required this.uri, required this.videoWidgetBuilder});

  @override
  Widget build(BuildContext context) {
    return videoWidgetBuilder(context: context, uri: uri);
  }
}
