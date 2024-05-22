import 'package:flutter/material.dart';
import 'package:flutter_chatflow/widgets/image/image_widget.dart';

class VideoMessageWidget extends StatelessWidget{
  final String uri;
  final String? text;
  const VideoMessageWidget({
    super.key,
    required this.uri,
    this.text
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ImageWidget(uri: uri),
          ),
          if(text != null) Text(text!)
        ],
      )
    );
  }
  
}