import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/widgets/image/image_swipe.dart';

/// ImageCarousel is used internally when a user taps and image.
///
/// This is the widget/screen that handles view images in full and manages swiping events automatically.
///
/// However, you can also use this class when sending calling your code to pick and upload images as a previewer
class ImageCarousel extends StatefulWidget {
  /// List of images that should be viewed.
  final List<ImageMessage> imageMessages;

  /// Current image index in the list of `imageMessages`
  final int? currentIndex;

  /// Create the image carousel.
  const ImageCarousel(
      {super.key, required this.imageMessages, this.currentIndex});

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

  handleSetCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "${currentIndex + 1} of ${_imageMessages.length}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                // Image And Buttons below
                ImagesSwipe(
                    currentIndex: currentIndex,
                    setCurrentIndex: handleSetCurrentIndex,
                    uri: _imageMessages[currentIndex].uri,
                    imagesLength: _imageMessages.length),
                // Text below if available
                const SizedBox(
                  height: 30,
                ),
                if (_imageMessages[currentIndex].text != null)
                  Text(
                    "${_imageMessages[currentIndex].text}",
                    style: const TextStyle(color: Colors.white),
                  )
              ],
            ),
          ),
        ));
  }
}
