import 'package:flutter/material.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/widgets/video/video_widget.dart';

class VideoMessageWidget extends StatelessWidget{
  final String uri;
  final String? text;
  final bool? isAuthor;
  final VideoWidgetBuilder videoWidgetBuilder;

  const VideoMessageWidget({
    super.key,
    required this.uri,
    required this.videoWidgetBuilder,
    this.text,
    this.isAuthor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: VideoWidget(uri: uri, videoWidgetBuilder: videoWidgetBuilder,),
          ),
          if(text != null && text!.isNotEmpty) Text(text!)
        ],
      )
    );
  }
  
}