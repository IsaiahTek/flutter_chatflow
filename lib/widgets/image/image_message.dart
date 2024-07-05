import 'package:flutter/material.dart';
import 'package:flutter_chatflow/widgets/image/image_widget.dart';

/// Image Message Widget for displaying images.
class ImageMessageWidget extends StatelessWidget {
  /// Pass in the uri/url of the image. This could be a server image or a local file
  final String uri;

  /// [Optional] text to be displayed at the bottom of the image
  final String? text;

  /// If set to true, the image appears to the right of the screen otherwise left of the screen.
  final bool isAuthor;

  /// Constructor of the Image Message Widget
  const ImageMessageWidget(
      {super.key, required this.uri, this.text, required this.isAuthor});

  /// Check and return if it is a text and not empty
  bool hasText() {
    if (text is String) {
      return text!.isNotEmpty;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: isAuthor
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(0))
              : const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
          child: ImageWidget(uri: uri),
        ),
        if (text != null && text!.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(text!),
          )
      ],
    ));
  }
}
