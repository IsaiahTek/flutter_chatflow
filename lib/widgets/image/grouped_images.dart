import 'package:flutter/material.dart';
import 'package:flutter_chatflow/message_gesture_callback_manager.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/utils/utils.dart';
import 'package:flutter_chatflow/widgets/chat_avatar.dart';
import 'package:flutter_chatflow/library.dart';
import 'package:flutter_chatflow/widgets/image/image_carousel.dart';

/// Internal use only
class GroupedImages extends StatelessWidget {
  /// Internal use only
  final List<ImageMessage> images;

  /// Internal use only
  final ChatUser chatUser;

  /// Internal use only
  final bool isGroupChat;

  /// Internal use only
  const GroupedImages(
      {super.key,
      required this.images,
      required this.chatUser,
      required this.isGroupChat});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: chatUser.userID == images.first.author.userID
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        ChatAvatar(
          showUserAvatarInChat: isGroupChat,
          author: images.first.author,
          chatUser: chatUser,
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 12),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (isGroupChat)
                    Container(
                        width: 300,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: chatUser.userID == images.first.author.userID
                                ? Theme.of(context)
                                    .primaryColor
                                    .withValues(alpha: .02)
                                : Colors.white,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Text(
                          "~${images.first.author.name ?? images.first.author.userID}",
                          style: TextStyle(
                              color: createColorFromHashCode(
                                      images.first.author.userID.hashCode)
                                  .main,
                              fontStyle: FontStyle.italic),
                        )),
                  Row(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        padding: const EdgeInsets.only(
                            left: 5, top: 5, right: 2.5, bottom: 2.5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: isGroupChat
                                ? null
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(20))),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18)),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          _ScrollableImagesView(
                                              images: images)));
                            },
                            child: _GroupedImage(
                              image: images[0],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        padding: const EdgeInsets.only(
                            left: 2.5, top: 5, right: 5, bottom: 2.5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: isGroupChat
                                ? null
                                : const BorderRadius.only(
                                    topRight: Radius.circular(20))),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(18)),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          _ScrollableImagesView(
                                              images: images)));
                            },
                            child: _GroupedImage(image: images[1]),
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
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20))),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(18)),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            _ScrollableImagesView(
                                                images: images)));
                              },
                              child: _GroupedImage(
                                image: images[2],
                              )),
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
                                  child: _GroupedImage(image: images[3]),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(18)),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  clipBehavior: Clip.antiAlias,
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
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
                                                child: ImageWidget(
                                                    uri: images[3].uri))),
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
                                                                images:
                                                                    images)));
                                              },
                                              child: Container(
                                                color: Colors.black
                                                    .withValues(alpha: .5),
                                                child: Center(
                                                    child: SizedBox(
                                                        width: 150,
                                                        height: 50,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const Icon(
                                                              Icons.add,
                                                              color:
                                                                  Colors.white,
                                                              size: 40,
                                                              applyTextScaling:
                                                                  true,
                                                            ),
                                                            Text(
                                                              "${images.length - 3}",
                                                              style: const TextStyle(
                                                                  fontSize: 32,
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          ],
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
        ),
      ],
    );
  }
}

class _GroupedImage extends StatelessWidget {
  final ImageMessage image;
  const _GroupedImage({required this.image});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.antiAlias,
      child: Stack(alignment: Alignment.center, children: [
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
                fit: BoxFit.cover, child: ImageWidget(uri: image.uri))),
        Positioned(
            bottom: 2,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withValues(alpha: .2),
              ),
              child: Text(
                getSentAt(image.createdAt),
                style: const TextStyle(shadows: [
                  Shadow(
                      offset: Offset(1, 1), blurRadius: 1, color: Colors.black)
                ], color: Colors.white),
              ),
            ))
      ]),
    );
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(images.first.author.name?.toUpperCase() ??
                images.first.author.userID.toUpperCase()),
            Text(
              "${images.length} Images * ${getWeekDayName(DateTime.fromMillisecondsSinceEpoch(images.first.createdAt).weekday)}",
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
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
                Stack(
                  children: [
                    GestureDetector(
                        onTap: () {
                          OnMessageGesture? onImageTapped =
                              MessageGestureCallbackManager.instance
                                  .getCallback(
                                      CallbackName.onImageMessageTapped);
                          if (onImageTapped != null) {
                            onImageTapped(images[index], (message) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => ImageCarousel(
                                            imageMessages: images,
                                            currentIndex: index,
                                          ))));
                            });
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => ImageCarousel(
                                          imageMessages: images,
                                          currentIndex: index,
                                        ))));
                          }
                        },
                        child: ImageWidget(uri: images[index].uri)),
                    Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withValues(alpha: .2),
                          ),
                          child: Text(
                            getSentAt(images[index].createdAt),
                            style: const TextStyle(shadows: [
                              Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 1,
                                  color: Colors.black)
                            ], color: Colors.white),
                          ),
                        ))
                  ],
                ),
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
