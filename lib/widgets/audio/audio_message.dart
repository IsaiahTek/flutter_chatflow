import 'package:flutter/material.dart';
import 'package:flutter_chatflow/widgets/image/image_widget.dart';

class AudioMessageWidget extends StatelessWidget{
  final String uri;
  final String? text;
  final bool? isAuthor;
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
      )
    );
  }
  
}