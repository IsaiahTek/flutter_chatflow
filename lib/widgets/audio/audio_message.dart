import 'package:flutter/material.dart';

/// Audio message widget
class AudioMessageWidget extends StatelessWidget {
  /// uri/url or local file path
  final String uri;

  /// [Optional] text
  final String? text;

  /// If set to true, widget is displayed to the right
  final bool? isAuthor;

  /// Audio message widget to display an audio message type
  const AudioMessageWidget({
    super.key,
    required this.uri,
    this.text,
    this.isAuthor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: const Column(
      children: [
        // ClipRRect(
        //   borderRadius: BorderRadius.circular(10),
        //   child: ImageWidget(uri: uri),
        // ),
        // if(text != null) Text(text!)
      ],
    ));
  }
}
