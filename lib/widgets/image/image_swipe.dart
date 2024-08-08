import 'package:flutter/material.dart';
import 'package:flutter_chatflow/library.dart';

// import 'package:flutter_chatflow/widgets/image/image_widget.dart';

/// Image Swipe Class Used by Carousel and other related classes
class ImagesSwipe extends StatefulWidget {
  /// Current image index
  final int currentIndex;

  /// Callback to set the current index
  final void Function(int index) setCurrentIndex;

  /// The image uri/url or path
  final String uri;

  /// Total number of images in the list
  final int imagesLength;

  /// Constructor
  const ImagesSwipe(
      {super.key,
      required this.currentIndex,
      required this.setCurrentIndex,
      required this.uri,
      required this.imagesLength});

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
            if (dragDx > 0 && widget.currentIndex > 0) {
              widget.setCurrentIndex(widget.currentIndex - 1);
            } else if (dragDx < 0 &&
                widget.imagesLength - 1 > widget.currentIndex) {
              widget.setCurrentIndex(widget.currentIndex + 1);
            }
          },
          child: ConstrainedBox(
            constraints: BoxConstraints.loose(Size(
                MediaQuery.of(context).size.width * 0.90,
                MediaQuery.of(context).size.height * 0.80)),
            child: ImageWidget(uri: widget.uri),
          ),
        ),

        // Right Arrow Button
      ],
    );
  }
}
