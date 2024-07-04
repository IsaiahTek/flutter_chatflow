import 'package:flutter/material.dart';
import 'package:flutter_chatflow/widgets/image/image_widget.dart';

class ImagesSwipe extends StatefulWidget{
  
  final int currentIndex;
  final void Function(int index) setCurrentIndex;
  final String uri;
  final int imagesLength;

  const ImagesSwipe({
    super.key,
    required this.currentIndex,
    required this.setCurrentIndex,
    required this.uri,
    required this.imagesLength

  });

  @override
  State<ImagesSwipe> createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImagesSwipe> {


  double dragDx = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Left Arror Button
        
        // Image
        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              dragDx = details.delta.dx;
            });
          },
          onHorizontalDragEnd: (details) {
            if(dragDx > 0 && widget.currentIndex > 0){
              widget.setCurrentIndex(widget.currentIndex-1);
            }else if(dragDx < 0 && widget.imagesLength - 1 > widget.currentIndex){
              widget.setCurrentIndex(widget.currentIndex+1);
            }
          },
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(
              Size(MediaQuery.of(context).size.width*0.90, MediaQuery.of(context).size.height*0.80)
            ),
            child: ImageWidget(uri: widget.uri),
          ),
        ),

        // Right Arrow Button

      ],
    );
  }
}