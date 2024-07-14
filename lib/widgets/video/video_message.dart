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

  /// [Optional] If false or not provide the text will be displayed under the image.
  /// Otherwise, the text will not be displayed.
  final bool? shouldHideText;

  /// [Optional] Internally used to scale image to fit available box
  final bool? shouldFitToAvailableSize;

  /// Video Message Widget
  const VideoMessageWidget(
      {super.key,
      required this.uri,
      required this.videoWidgetBuilder,
      this.text,
      this.isAuthor,
      this.shouldFitToAvailableSize,
      this.shouldHideText});

  /// Check and return if it is a text and not empty
  bool hasText() {
    if (text is String) {
      return text!.isNotEmpty && !(shouldHideText ?? false);
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Column(
      children: [
        shouldFitToAvailableSize != null && shouldFitToAvailableSize!
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: VideoWidget(
                      uri: uri,
                      videoWidgetBuilder: videoWidgetBuilder,
                    ),
                  ),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: VideoWidget(
                  uri: uri,
                  videoWidgetBuilder: videoWidgetBuilder,
                ),
              ),
        if (hasText())
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(text!),
          )
      ],
    ));
  }
}
