import 'package:flutter/material.dart';
import 'package:flutter_chatflow/widgets/image/image_widget.dart';

class ImageMessageWidget extends StatelessWidget{
  final String uri;
  final String? text;
  final bool? isAuthor;
  const ImageMessageWidget({
    super.key,
    required this.uri,
    this.text,
    this.isAuthor
  });

  bool get _isAuthor => isAuthor??false; 

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: 
            //_isAuthor ? 
            BorderRadius.circular(10),
            // : const BorderRadius.only(
            //   bottomLeft: Radius.circular(0),
            //   topRight: Radius.circular(10),
            //   topLeft: Radius.circular(10),
            //   bottomRight: Radius.circular(10)
            // ),
            child: ImageWidget(uri: uri),
          ),
          if(text != null) Text(text!)
        ],
      )
    );
  }
  
}