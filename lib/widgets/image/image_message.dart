import 'package:flutter/material.dart';
import 'package:flutter_chatflow/widgets/image/image_widget.dart';

class ImageMessageWidget extends StatelessWidget{
  final String uri;
  final String? text;
  final bool isAuthor;
  const ImageMessageWidget({
    super.key,
    required this.uri,
    this.text,
    required this.isAuthor
  });

  bool hasText(){
    if(text is String){
      return text!.isNotEmpty;
    }else{
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
            borderRadius: 
            isAuthor 
            ? const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(0)
            )
            : const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)
            ),
            child: ImageWidget(uri: uri),
          ),
          if(text != null && text!.isNotEmpty) Container(
            padding: const EdgeInsets.all(5),
            child: Text(text!),
          )
        ],
      )
    );
  }
  
}