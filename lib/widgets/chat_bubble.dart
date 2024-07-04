import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
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
  final CustomWidgetBuilder? videoWidgetBuilder;
  final CustomWidgetBuilder? pdfWidgetBuilder;
  final CustomWidgetBuilder? customWidgetBuilder;

  const ChatBubble({
    super.key,
    required this.message,
    required this.currentMessageIndex,
    required this.chatUser,
    required this.imageMessages,
    required this.showUserAvatarInChat,
    this.previousMessageCreatedAt,
    required this.setSelectedMessages,
    required this.selectedMessages,
    this.videoWidgetBuilder,
    this.pdfWidgetBuilder,
    this.customWidgetBuilder
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {

  Message get selectedMessage => widget.selectedMessages[widget.selectedMessages.length-1];

  List<Message> get selectedMessages => widget.selectedMessages;

  handleSetSelectedMessage(Message message){
    if(selectedMessages.contains(message)){
      selectedMessages.remove(message);
    }else{
      selectedMessages.add(message);
    }
    widget.setSelectedMessages(selectedMessages);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimePartitionText(
          createdAt: widget.message.createdAt,
          previousMessageCreatedAt: widget.previousMessageCreatedAt
        ),
        
        if(widget.message.type == MessageType.info)
        _InfoMessage(message: widget.message)
        
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

            // Message And Delivery Info Widget
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Message Container
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
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: 
                  // Stack(
                  //   children: [
                      GestureDetector(
                        onTap: (){
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
                                // width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.003),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  "~${widget.message.author.name != null && widget.message.author.name!.isNotEmpty? widget.message.author.name : widget.message.author.userID}",
                                  overflow: TextOverflow.ellipsis,
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
                                  customWidgetBuilder: widget.customWidgetBuilder,
                                  pdfWidgetBuilder: widget.pdfWidgetBuilder,
                                  videoWidgetBuilder: widget.videoWidgetBuilder,
                                ),
                              ),
                            ],
                          )
                        ),
                      ),

                  //   ],
                  // )
                ),

                // Message Delivery Widget
                Container(
                  margin: const EdgeInsets.only(right: 10, bottom: 10),
                  child: Row(
                    // alignment: Alignment.bottomRight,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        getSentAt(widget.message.createdAt),
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: Theme.of(context).textTheme.labelSmall?.fontSize
                        ),
                      ),
                      if(widget.message.status != null)
                      Wrap(
                        children: [
                          const SizedBox(width: 5,),
                          SizedBox(
                            height: Theme.of(context).textTheme.labelSmall?.fontSize, // Adjust height and width as needed
                            width: Theme.of(context).textTheme.labelSmall?.fontSize,
                            child: _DeliveryStateIcon(deliveryStatus: widget.message.status),
                          )
                        ],
                      )
                    ]
                  )
                )
              ],
            )
          ],
        )
      ],
    );
  }
}

class _TimePartitionText extends StatelessWidget{

  final int? previousMessageCreatedAt;
  final int createdAt;

  const _TimePartitionText({
    required this.createdAt,
    this.previousMessageCreatedAt
  });
  
  @override
  Widget build(BuildContext context) {
    return ( !isSameDay(previousMessageCreatedAt, createdAt) )
    ? Row(
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
              computeTimePartitionText(createdAt),
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: Theme.of(context).textTheme.labelSmall?.fontSize
              ),
            ),
          ),
        )
      ],
    )
    : const SizedBox.shrink();
  }
}

class _InfoMessage extends StatelessWidget{
  final Message message;
  const _InfoMessage({required this.message});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints.loose(MediaQuery.of(context).size),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
              (message as ChatInfo).info,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: Theme.of(context).textTheme.labelSmall?.fontSize
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _DeliveryStateIcon extends StatelessWidget{

  final DeliveryStatus? deliveryStatus;

  const _DeliveryStateIcon({
    this.deliveryStatus
  });

  @override
  Widget build(BuildContext context) {
    late Widget icon;
    double iconSize = Theme.of(context).textTheme.labelSmall?.fontSize??14;
    switch (deliveryStatus) {
      case DeliveryStatus.sending:
        icon = const CircularProgressIndicator(
          strokeWidth: 1.5,
        );
        break;
      case DeliveryStatus.sent:
        icon = Icon(Icons.done_rounded, size: iconSize,);
        break;
      case DeliveryStatus.delivered:
        icon = Icon(Icons.done_all_rounded, size: iconSize,);
        break;
      case DeliveryStatus.read:
        icon = Icon(Icons.done_all_rounded, color: Theme.of(context).primaryColor, size: iconSize,);
        break;
      default:
        icon = const SizedBox();
    }
    return icon;
  }
}