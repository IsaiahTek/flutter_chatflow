import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chatflow/widgets/image/image_widget.dart';

/// Image Message Widget for displaying images.
class ImageMessageWidget extends StatelessWidget {
  /// Pass in the uri/url of the image. This could be a server image or a local file
  final String uri;

  /// [Optional] text to be displayed at the bottom of the image
  final String? text;

  /// If set to true, the image appears to the right of the screen otherwise left of the screen.
  final bool isAuthor;

  /// [Optional] If false or not provide the text will be displayed under the image.
  /// Otherwise, the text will not be displayed.
  final bool? shouldHideText;

  /// [Optional] Internally used to scale image to fit available box
  final bool? shouldFitToAvailableSize;

  /// Constructor of the Image Message Widget
  const ImageMessageWidget(
      {super.key,
      required this.uri,
      this.text,
      required this.isAuthor,
      this.shouldHideText,
      this.shouldFitToAvailableSize});

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        shouldFitToAvailableSize != null && shouldFitToAvailableSize!
            ? ClipRRect(
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
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child:
                      FittedBox(fit: BoxFit.fill, child: ImageWidget(uri: uri)),
                ),
              )
            : ClipRRect(
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
        if (hasText())
          Container(
            padding: const EdgeInsets.all(5),
            child: Text(text!),
          )
      ],
    );
  }
}
