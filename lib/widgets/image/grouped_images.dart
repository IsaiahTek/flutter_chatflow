import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/widgets/image/image_widget.dart';

/// Internal use only
class GroupedImages extends StatelessWidget {
  /// Internal use only
  final List<ImageMessage> images;

  /// Internal use only
  final ChatUser chatUser;

  /// Internal use only
  const GroupedImages(
      {super.key, required this.images, required this.chatUser});

  @override
  Widget build(BuildContext context) {
    // return LayoutBuilder(
    //   builder: (context, constraints) {
    //     final parentWidth = constraints.minWidth;
    //     final containerWidth = parentWidth / 2;

    debugPrint(
        "GROUPED MESSAGES LENGTH: ${images.length} AND IS CHAT USER: ${images.first.author.userID == chatUser.userID}");

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 12),
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    padding: const EdgeInsets.only(
                        left: 5, top: 5, right: 2.5, bottom: 2.5),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(20))),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(18)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      _ScrollableImagesView(images: images)));
                        },
                        child: FittedBox(
                            fit: BoxFit.cover,
                            clipBehavior: Clip.antiAlias,
                            child: ImageWidget(uri: images[0].uri)),
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    padding: const EdgeInsets.only(
                        left: 2.5, top: 5, right: 5, bottom: 2.5),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(20))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(18)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      _ScrollableImagesView(images: images)));
                        },
                        child: FittedBox(
                            fit: BoxFit.cover,
                            clipBehavior: Clip.antiAlias,
                            child: ImageWidget(uri: images[1].uri)),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    padding: const EdgeInsets.only(
                        left: 5, top: 2.5, right: 2.5, bottom: 5),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(20))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(18)),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      _ScrollableImagesView(images: images)));
                        },
                        child: FittedBox(
                            fit: BoxFit.cover,
                            clipBehavior: Clip.antiAlias,
                            child: ImageWidget(uri: images[2].uri)),
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 150,
                    padding: const EdgeInsets.only(
                        left: 2.5, top: 2.5, right: 5, bottom: 5),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20))),
                    child: images.length < 5
                        ? ClipRRect(
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(18)),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            _ScrollableImagesView(
                                                images: images)));
                              },
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  clipBehavior: Clip.antiAlias,
                                  child: ImageWidget(uri: images[3].uri)),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(18)),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              clipBehavior: Clip.antiAlias,
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                const SizedBox(
                                  height: 150,
                                  width: 150,
                                ),
                                Positioned(
                                    top: 0,
                                    width: 150,
                                    left: 0,
                                    height: 150,
                                    child: FittedBox(
                                        fit: BoxFit.cover,
                                        child:
                                            ImageWidget(uri: images[3].uri))),
                                Positioned(
                                    top: 0,
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    _ScrollableImagesView(
                                                        images: images)));
                                      },
                                      child: Container(
                                        color: Colors.black.withOpacity(.5),
                                        child: const Center(
                                            child: SizedBox(
                                                width: 50,
                                                height: 50,
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 40,
                                                  applyTextScaling: true,
                                                ))),
                                      ),
                                    ))
                              ]),
                            )),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
    // },
    // );
  }
}

class _ScrollableImagesView extends StatelessWidget {
  final List<ImageMessage> images;
  const _ScrollableImagesView({required this.images});

  bool hasText(String? text) {
    if (text is String) {
      return text.isNotEmpty;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Images"),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            color: Colors.black,
            // padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: [
                ImageWidget(uri: images[index].uri),
                if (hasText(images[index].text))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      images[index].text!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
