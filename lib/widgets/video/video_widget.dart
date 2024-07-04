import 'package:flutter/material.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';

class VideoWidget extends StatelessWidget{

  final String uri;
  final VideoWidgetBuilder videoWidgetBuilder;

  const VideoWidget({
    super.key,
    required this.uri,
    required this.videoWidgetBuilder
  });

  @override
  Widget build(BuildContext context) {
    return videoWidgetBuilder(context: context, uri: uri);
  }
  
}