import 'package:flutter/material.dart';
import 'package:fluchat/chat.dart';
import 'package:fluchat/widgets/image_widget.dart';

class ImageCarousel extends StatefulWidget{

  final List<ImageMessage> imageMessages;
  final int? currentIndex;
  const ImageCarousel({
    super.key,
    required this.imageMessages,
    this.currentIndex
  });

  @override
  State<StatefulWidget> createState() => _ImageCarouselState();

}

class _ImageCarouselState extends State<ImageCarousel> {

  List<ImageMessage> get _imageMessages => widget.imageMessages;

  late int currentIndex;

  double dragDx = 0;

  @override
  void initState() {
    currentIndex = widget.currentIndex ?? 0;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image And Buttons below
          Row(
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
                  debugPrint("Swiped to $dragDx");
                  if(dragDx > 0 && currentIndex > 0){
                    setState(() {
                      currentIndex -= 1;
                    });
                  }else if(dragDx < 0 && _imageMessages.length - 1 > currentIndex){
                    setState(() {
                      currentIndex += 1;
                    });
                  }
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints.loose(
                    Size(MediaQuery.of(context).size.width*0.90, MediaQuery.of(context).size.height*0.80)
                  ),
                  child: ImageWidget(uri: _imageMessages[currentIndex].uri),
                ),
              ),

              // Right Arrow Button

            ],
          ),
          // Text below if available
          if(_imageMessages[currentIndex].text != null)
          Text("${_imageMessages[currentIndex].text}")
        ],
      )
    );
  }
}