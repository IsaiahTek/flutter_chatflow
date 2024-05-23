import 'package:flutter/material.dart';
import 'package:flutter_chatflow/chatflow.dart';
import 'package:flutter_chatflow/utils.dart';
import 'package:flutter_chatflow/widgets/chat_avatar.dart';
import 'package:flutter_chatflow/widgets/computed_widget.dart';
import 'package:flutter_chatflow/widgets/image/image_carousel.dart';

class ChatBubble extends StatelessWidget{
  
  final Message message;
  final ChatUser chatUser;
  final List<ImageMessage> imageMessages;
  final bool showUserAvatarInChat;
  final int? previousMessageCreatedAt;

  const ChatBubble({
    super.key,
    required this.message,
    required this.chatUser,
    required this.imageMessages,
    required this.showUserAvatarInChat,
    required this.previousMessageCreatedAt
  });

  bool isSameDay(int? previousMessageTime, int currentMessageTime){
    int? previousDay = previousMessageTime != null ? DateTime.fromMillisecondsSinceEpoch(previousMessageTime).day: null;
    int currentDay = DateTime.fromMillisecondsSinceEpoch(currentMessageTime).day;
    int deltaDay = previousDay != null? currentDay - previousDay : 1;

    return deltaDay == 0;
  }

    

  String computeTimePartitionText(int millisecondsSinceEpoch){
    DateTime date = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    DateTime now = DateTime.now();
    int longAgo = now.day - date.day;
    String result;
    switch (longAgo) {
      case 0:
        result = "TODAY";
        break;
      case 1:
        result = "YESTERDAY";
        break;
      default:
        if(longAgo <= 6){
          result = getWeekDayName(date.weekday);
        }else{
          result = '${date.day}/${date.month}/${date.year}';
        }

    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(!isSameDay(
          previousMessageCreatedAt,
          message.createdAt
        ))
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white10),
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(5),
                child: Text(
                  computeTimePartitionText(message.createdAt),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: Theme.of(context).textTheme.labelSmall?.fontSize
                  ),
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: chatUser.userID == message.author.userID ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            ChatAvatar(
              showUserAvatarInChat: showUserAvatarInChat,
              author: message.author,
              chatUser: chatUser,
            ),
            Container(
              constraints: BoxConstraints.loose(Size.fromWidth(MediaQuery.of(context).size.width*.75)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: chatUser.userID == message.author.userID ? const Radius.circular(10):Radius.zero,
                  bottomRight: chatUser.userID != message.author.userID ? const Radius.circular(10):Radius.zero,
                ),
                color: chatUser.userID == message.author.userID ? Theme.of(context).primaryColor.withOpacity(.2) : Colors.white,
              ),
              padding: showUserAvatarInChat && chatUser.userID != message.author.userID? const EdgeInsets.only(top: 0, right: 0, bottom: 0) : EdgeInsets.symmetric(
                horizontal: message.type == MessageType.text ? 15 : 2,
                vertical: message.type == MessageType.text ? 10 : 2
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: (){
                      debugPrint("Taped message");
                      int currentImageIndex = imageMessages.indexWhere((element) => element.createdAt == message.createdAt);
                      if(message.type == MessageType.image){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => ImageCarousel(imageMessages: imageMessages, currentIndex: currentImageIndex,))
                          )
                        );
                      }
                    },
                    onLongPress: ()=>debugPrint("Long Press message"),
                    child: SizedBox(
                      // EXTRACTED HERE
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showUserAvatarInChat && chatUser.userID != message.author.userID)
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.003),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              "~${message.author.name??message.author.userID}",
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontStyle: FontStyle.italic,
                                color: createColorFromHashCode(message.author.userID.hashCode)
                              ),
                            ),
                          ),
                          Container(
                            padding: showUserAvatarInChat && chatUser.userID != message.author.userID && message.type == MessageType.text? const EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 8) : const EdgeInsets.all(0),
                            child: ComputedMessage(
                              message: message,
                              isAuthor: message.author.userID == chatUser.userID,
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      getSentAt(message.createdAt),
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.labelSmall?.fontSize
                      ),
                    )
                  )

                ],
              )
            )
          ],
        )
      ],
    );
  }
}