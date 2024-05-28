import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/utils/utils.dart';
import 'package:flutter_chatflow/widgets/chat_avatar.dart';
import 'package:flutter_chatflow/widgets/computed_widget.dart';
import 'package:flutter_chatflow/widgets/image/image_carousel.dart';

class ChatBubble extends StatefulWidget{
  
  final Message message;
  final int currentMessageIndex;
  final ChatUser chatUser;
  final List<ImageMessage> imageMessages;
  final bool showUserAvatarInChat;
  final int? previousMessageCreatedAt;
  final void Function(List<Message> message) setSelectedMessages;
  final List<Message> selectedMessages;

  const ChatBubble({
    super.key,
    required this.message,
    required this.currentMessageIndex,
    required this.chatUser,
    required this.imageMessages,
    required this.showUserAvatarInChat,
    this.previousMessageCreatedAt,
    required this.setSelectedMessages,
    required this.selectedMessages
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  
  bool isSameDay(int? previousMessageTime, int currentMessageTime){
    int? previousDay = previousMessageTime != null ? DateTime.fromMillisecondsSinceEpoch(previousMessageTime).day: null;
    int currentDay = DateTime.fromMillisecondsSinceEpoch(currentMessageTime).day;
    int deltaDay = previousDay != null? currentDay - previousDay : 1;

    return deltaDay == 0;
  }

  Message get selectedMessage => widget.selectedMessages[widget.selectedMessages.length-1];

  List<Message> get selectedMessages => widget.selectedMessages;

  handleSetSelectedMessage(Message index){
    if(selectedMessages.contains(index)){
      selectedMessages.remove(index);
    }else{
      selectedMessages.add(index);
    }
    widget.setSelectedMessages(selectedMessages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(!isSameDay(
          widget.previousMessageCreatedAt,
          widget.message.createdAt
        ))
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0.00, 0.5),
                      color: Colors.black26,
                    )
                  ]
                  
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  computeTimePartitionText(widget.message.createdAt),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: Theme.of(context).textTheme.labelSmall?.fontSize
                  ),
                ),
              ),
            )
          ],
        ),
        if(widget.message.type == MessageType.info)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.yellow[50],
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0.00, 0.5),
                      color: Colors.black26,
                    )
                  ]
                  
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Text(
                  (widget.message as ChatInfo).info,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: Theme.of(context).textTheme.labelSmall?.fontSize
                  ),
                ),
              ),
            )
          ],
        )
        else
        Row(
          mainAxisAlignment: widget.chatUser.userID == widget.message.author.userID ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            ChatAvatar(
              showUserAvatarInChat: widget.showUserAvatarInChat,
              author: widget.message.author,
              chatUser: widget.chatUser,
            ),
            if(widget.selectedMessages.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.black12),
                borderRadius: BorderRadius.circular(3),
                color: Colors.white
              ),
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(3),
              child: GestureDetector(
                onTap: () {
                  handleSetSelectedMessage(widget.message);
                },
                child: Icon(Icons.check, color: selectedMessages.contains(widget.message) ? Theme.of(context).primaryColor: Colors.black12,),
              ),
            ),
            Container(
              constraints: BoxConstraints.loose(Size.fromWidth(MediaQuery.of(context).size.width*.70)),
              decoration: BoxDecoration(
                boxShadow: [
                  if(widget.chatUser.userID != widget.message.author.userID)
                  BoxShadow(
                    offset: widget.chatUser.userID != widget.message.author.userID ? const Offset(0.00, 1) : const Offset(-3, 4),
                    color: widget.chatUser.userID != widget.message.author.userID ? Colors.black26 : const Color.fromARGB(255, 238, 238, 238),
                    // blurRadius: 10.0,
                    
                  )
                ],
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  topRight: const Radius.circular(10),
                  bottomLeft: widget.chatUser.userID == widget.message.author.userID ? const Radius.circular(10):Radius.zero,
                  bottomRight: widget.chatUser.userID != widget.message.author.userID ? const Radius.circular(10):Radius.zero,
                ),
                color: widget.chatUser.userID == widget.message.author.userID ? Theme.of(context).primaryColor.withOpacity(.1) : Colors.white
              ),
              padding: widget.showUserAvatarInChat && widget.chatUser.userID != widget.message.author.userID? const EdgeInsets.only(top: 0, right: 0, bottom: 0) : EdgeInsets.symmetric(
                horizontal: widget.message.type == MessageType.text ? 15 : 2,
                vertical: widget.message.type == MessageType.text ? 10 : 2
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: (){
                      debugPrint("Taped message");
                      int currentImageIndex = widget.imageMessages.indexWhere((element) => element.createdAt == widget.message.createdAt);
                      if(widget.message.type == MessageType.image){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => ImageCarousel(imageMessages: widget.imageMessages, currentIndex: currentImageIndex,))
                          )
                        );
                      }
                    },
                    onLongPress: (){
                      handleSetSelectedMessage(widget.message);
                    },
                    child: SizedBox(
                      // EXTRACTED HERE
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.showUserAvatarInChat && widget.chatUser.userID != widget.message.author.userID)
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
                              "~${widget.message.author.name??widget.message.author.userID}",
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontStyle: FontStyle.italic,
                                color: createColorFromHashCode(widget.message.author.userID.hashCode)
                              ),
                            ),
                          ),
                          Container(
                            padding: widget.showUserAvatarInChat && widget.chatUser.userID != widget.message.author.userID && widget.message.type == MessageType.text? const EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 8) : const EdgeInsets.all(0),
                            child: ComputedMessage(
                              message: widget.message,
                              isAuthor: widget.message.author.userID == widget.chatUser.userID,
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      getSentAt(widget.message.createdAt),
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