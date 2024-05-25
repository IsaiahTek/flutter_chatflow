import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/widgets/image/image_swipe.dart';

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

  @override
  void initState() {
    currentIndex = widget.currentIndex ?? 0;
    super.initState();
  }

  handleSetCurrentIndex(int index){
    setState(() {
      currentIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image And Buttons below
          ImagesSwipe(currentIndex: currentIndex, setCurrentIndex: handleSetCurrentIndex, uri: _imageMessages[currentIndex].uri, imagesLength: _imageMessages.length),
          // Text below if available
          const SizedBox(height: 30,),
          if(_imageMessages[currentIndex].text != null)
          Text("${_imageMessages[currentIndex].text}", style: const TextStyle(color: Colors.white),)
        ],
      )
    );
  }
}