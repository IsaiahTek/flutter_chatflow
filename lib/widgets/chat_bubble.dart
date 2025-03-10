import 'package:flutter/material.dart';
import 'package:flutter_chatflow/message_gesture_callback_manager.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/utils/utils.dart';
import 'package:flutter_chatflow/widgets/chat_avatar.dart';
import 'package:flutter_chatflow/widgets/sent_at.dart';
import '../library.dart';
import 'package:flutter_chatflow/widgets/image/image_carousel.dart';
import 'package:flutter_chatflow/widgets/replied_message_widget.dart';

/// Chat Bubble Class
class ChatBubble extends StatefulWidget {
  /// Current message
  final Message message;

  /// Index of the current message
  final int currentMessageIndex;

  /// current ChatUser
  final ChatUser chatUser;

  /// List of image messages
  final List<ImageMessage> imageMessages;

  /// Set to true for all peers in group chat to have their avatar shown
  final bool showUserAvatarInChat;

  /// timestamp of previous message
  final int? previousMessageCreatedAt;

  /// Callback to set selected messages
  final void Function(List<Message> message) setSelectedMessages;

  /// List of selected messages
  final List<Message> selectedMessages;

  /// Video widget to be used for displaying video messages
  final CustomWidgetBuilder? videoWidgetBuilder;

  /// PDF widget to be used for displaying PDF messages
  final CustomWidgetBuilder? pdfWidgetBuilder;

  /// Custom widget to be used for displaying Custom messages
  final CustomWidgetBuilder? customWidgetBuilder;

  /// Set Replying Message
  final void Function(Message reply) setReplyMessage;

  /// When a replied message preview is tapped
  final void Function(Message reply)? onTappedRepliedMessagePreview;

  /// Chat Bubble.
  const ChatBubble(
      {super.key,
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
      this.customWidgetBuilder,
      this.onTappedRepliedMessagePreview,
      required this.setReplyMessage});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  List<Message> get selectedMessages => widget.selectedMessages;

  double? _left;
  double? _right;

  void _onHorizontalDragUpdate(DragUpdateDetails details, bool isAuthor) {
    if (isAuthor && details.delta.dx < 0 && details.delta.dx > -10) {
      _right = null;
      _left = _left != null ? _left! + details.delta.dx : details.delta.dx;
    } else if (!isAuthor && details.delta.dx > 0) {
      _left = null;
      _right = _right != null ? _right! - details.delta.dx : details.delta.dx;
    }
    setState(() {
      _right;
      _left;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details, bool isAuthor) {
    if ((_left != null && _left! != 0) || (_right != null && _right! != 0)) {
      widget.setReplyMessage(widget.message);
    }
    setState(() {
      if (isAuthor) {
        _left = null;
        _right = 0;
      } else {
        _left = 0;
        _right = null;
      }
    });
  }

  _handleSetSelectedMessage(Message message) {
    if (selectedMessages.contains(message)) {
      selectedMessages.remove(message);
    } else {
      selectedMessages.add(message);
    }
    widget.setSelectedMessages(selectedMessages);
  }

  @override
  void initState() {
    super.initState();
    if (widget.chatUser.userID == widget.message.author.userID) {
      _right = 0;
    } else {
      _left = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TimePartitionText(
            createdAt: widget.message.createdAt,
            previousMessageCreatedAt: widget.previousMessageCreatedAt),
        if (widget.message.type == MessageType.info)
          _InfoMessage(message: widget.message)
        else
          Row(
            children: [
              if (selectedMessages.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    if (selectedMessages.isNotEmpty) {
                      _handleSetSelectedMessage(widget.message);
                    } else {
                      FocusScope.of(context).unfocus();
                    }
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 4, color: Theme.of(context).primaryColor),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50)),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 4,
                              color: Colors.white)
                        ]),
                    child: selectedMessages.contains(widget.message)
                        ? Container(
                            margin: const EdgeInsets.all(2),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50))),
                          )
                        : Container(
                            color: Colors.transparent,
                          ),
                  ),
                ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                      mainAxisAlignment:
                          widget.chatUser.userID == widget.message.author.userID
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChatAvatar(
                          showUserAvatarInChat: widget.showUserAvatarInChat,
                          author: widget.message.author,
                          chatUser: widget.chatUser,
                        ),

                        // Message And Delivery Info Widget
                        GestureDetector(
                          onHorizontalDragUpdate: (u) =>
                              _onHorizontalDragUpdate(
                                  u,
                                  widget.chatUser.userID ==
                                      widget.message.author.userID),
                          onHorizontalDragEnd: (e) => _onHorizontalDragEnd(
                              e,
                              widget.chatUser.userID ==
                                  widget.message.author.userID),
                          child: Transform.translate(
                            offset: Offset(
                                _left ?? (_right != null ? 0 - _right! : 0), 0),
                            child: Stack(
                              children: [
                                // Message Container
                                _MessageWidget(
                                  message: widget.message,
                                  chatUser: widget.chatUser,
                                  imageMessages: widget.imageMessages,
                                  handleSetSelectedMessage:
                                      _handleSetSelectedMessage,
                                  customWidgetBuilder:
                                      widget.customWidgetBuilder,
                                  pdfWidgetBuilder: widget.pdfWidgetBuilder,
                                  videoWidgetBuilder: widget.videoWidgetBuilder,
                                  showUserAvatarInChat:
                                      widget.showUserAvatarInChat,
                                  onTappedRepliedMessagePreview:
                                      widget.onTappedRepliedMessagePreview,
                                ),
                                // Message Delivery Widget
                                Positioned(
                                  bottom: -10,
                                  right: 10,
                                  child: _MessageDeliveryWidget(
                                      message: widget.message,
                                      chatUser: widget.chatUser),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]),
                ),
              ),
            ],
          )
      ],
    );
  }
}

class _TimePartitionText extends StatelessWidget {
  final int? previousMessageCreatedAt;
  final int createdAt;

  const _TimePartitionText(
      {required this.createdAt, this.previousMessageCreatedAt});

  @override
  Widget build(BuildContext context) {
    return (!isSameDay(previousMessageCreatedAt, createdAt))
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
                      ]),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    computeTimePartitionText(createdAt),
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize:
                            Theme.of(context).textTheme.labelSmall?.fontSize),
                  ),
                ),
              )
            ],
          )
        : const SizedBox.shrink();
  }
}

class _InfoMessage extends StatelessWidget {
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
                ]),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              (message as ChatInfo).info,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: Theme.of(context).textTheme.labelSmall?.fontSize),
            ),
          ),
        )
      ],
    );
  }
}

class _DeliveryStatusIcon extends StatelessWidget {
  final DeliveryStatus? deliveryStatus;
  final bool? isAtText;

  const _DeliveryStatusIcon({this.deliveryStatus, this.isAtText});

  bool get _isAtText => isAtText ?? true;

  @override
  Widget build(BuildContext context) {
    late Widget icon;
    double iconSize = Theme.of(context).textTheme.labelSmall?.fontSize ?? 14;
    switch (deliveryStatus) {
      case DeliveryStatus.sending:
        icon = CircularProgressIndicator(
          strokeWidth: 1.5,
          color: _isAtText ? null : Colors.white,
        );
        break;
      case DeliveryStatus.sent:
        icon = Icon(
          Icons.done_rounded,
          size: iconSize,
          color: _isAtText ? Colors.black87 : Colors.white,
        );
        break;
      case DeliveryStatus.delivered:
        icon = Icon(
          Icons.done_all_rounded,
          size: iconSize,
          color: _isAtText ? Colors.black87 : Colors.white,
        );
        break;
      case DeliveryStatus.read:
        icon = Icon(
          Icons.done_all_rounded,
          color: Theme.of(context).primaryColor,
          size: iconSize,
        );
        break;
      default:
        icon = const SizedBox();
    }
    return icon;
  }
}

bool _deliveryIsShownAtTextPoint(Message message) {
  final MessageType messageType = message.type;
  bool messageHasText = false;
  switch (messageType) {
    case MessageType.text:
      messageHasText = true;
      break;
    default:
  }
  return messageHasText;
}

class _MessageDeliveryWidget extends StatelessWidget {
  final Message message;
  final ChatUser chatUser;
  const _MessageDeliveryWidget({required this.message, required this.chatUser});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            right: 5, bottom: message.type != MessageType.text ? 15 : 5),
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: !_deliveryIsShownAtTextPoint(message)
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withValues(alpha: .2),
              )
            : null,
        child: Row(
            // alignment: Alignment.bottomRight,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SentAt(type: message.type, timestamp: message.createdAt),
              if (message.status != null &&
                  message.author.userID == chatUser.userID)
                Wrap(
                  children: [
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      height: Theme.of(context)
                          .textTheme
                          .labelSmall
                          ?.fontSize, // Adjust height and width as needed
                      width: Theme.of(context).textTheme.labelSmall?.fontSize,
                      child: _DeliveryStatusIcon(
                        deliveryStatus: message.status,
                        isAtText: _deliveryIsShownAtTextPoint(message),
                      ),
                    )
                  ],
                )
            ]));
  }
}

class _MessageWidget extends StatelessWidget {
  final Message message;
  final ChatUser chatUser;
  final bool showUserAvatarInChat;
  final List<ImageMessage> imageMessages;
  final void Function(Message message) handleSetSelectedMessage;
  final CustomWidgetBuilder? customWidgetBuilder;
  final CustomWidgetBuilder? videoWidgetBuilder;
  final CustomWidgetBuilder? pdfWidgetBuilder;
  final Function(Message message)? onTappedRepliedMessagePreview;

  const _MessageWidget(
      {required this.message,
      required this.chatUser,
      required this.imageMessages,
      required this.showUserAvatarInChat,
      required this.handleSetSelectedMessage,
      required this.customWidgetBuilder,
      required this.pdfWidgetBuilder,
      required this.videoWidgetBuilder,
      this.onTappedRepliedMessagePreview});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        OnMessageGesture? onLongPressed = MessageGestureCallbackManager.instance
            .getCallback(CallbackName.onMessageLongPressed);
        if (onLongPressed != null) {
          onLongPressed(message, handleSetSelectedMessage);
        } else {
          handleSetSelectedMessage(message);
        }
      },
      onDoubleTap: () {
        OnMessageGesture? onDoubleTapped = MessageGestureCallbackManager
            .instance
            .getCallback(CallbackName.onMessageDoubleTapped);
        if (onDoubleTapped != null) {
          onDoubleTapped(message, (Message message) {});
        } else {}
      },
      // onTap: (){
      //   if(message.type == MessageType.image && onImageMessageTapped != null){
      //     onImageMessageTapped!(message, (Message message){});
      //   }
      // },
      child: Container(
        constraints: BoxConstraints(
            minWidth: 100, maxWidth: MediaQuery.of(context).size.width * .60),
        decoration: BoxDecoration(
            boxShadow: [
              if (chatUser.userID != message.author.userID)
                BoxShadow(
                  offset: chatUser.userID != message.author.userID
                      ? const Offset(0.00, 1)
                      : const Offset(-3, 4),
                  color: chatUser.userID != message.author.userID
                      ? Colors.black26
                      : const Color.fromARGB(255, 238, 238, 238),
                  // blurRadius: 10.0,
                )
            ],
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
              bottomLeft: chatUser.userID == message.author.userID
                  ? const Radius.circular(10)
                  : Radius.zero,
              bottomRight: chatUser.userID != message.author.userID
                  ? const Radius.circular(10)
                  : Radius.zero,
            ),
            color: chatUser.userID == message.author.userID
                ? Theme.of(context).primaryColor.withValues(alpha: .1)
                : Colors.white),
        padding:
            showUserAvatarInChat && chatUser.userID != message.author.userID
                ? const EdgeInsets.only(top: 2, right: 2, bottom: 2, left: 2)
                : EdgeInsets.only(
                    left: message.type == MessageType.text ? 15 : 2,
                    right: message.type == MessageType.text ? 15 : 2,
                    top: message.type == MessageType.text ? 10 : 2,
                    bottom: message.type == MessageType.text ? 20 : 2),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
        child: GestureDetector(
          onTap: () {
            if (message.type == MessageType.image) {
              int currentImageIndex =
                  imageMessages.indexWhere((element) => element == message);
              OnMessageGesture? onImageTapped = MessageGestureCallbackManager
                  .instance
                  .getCallback(CallbackName.onImageMessageTapped);
              if (onImageTapped != null) {
                Message message = imageMessages[currentImageIndex];
                onImageTapped(message, (message) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => ImageCarousel(
                                imageMessages: imageMessages,
                                currentIndex: currentImageIndex,
                              ))));
                });
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => ImageCarousel(
                              imageMessages: imageMessages,
                              currentIndex: currentImageIndex,
                            ))));
              }
            }
          },
          child: SizedBox(
              // EXTRACTED HERE
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.repliedTo != null)
                GestureDetector(
                  onTap: () {
                    if (onTappedRepliedMessagePreview != null) {
                      onTappedRepliedMessagePreview!(message.repliedTo!);
                    }
                  },
                  child: RepliedMessageWidget(
                    replyMessage: message.repliedTo!,
                    isAuthor:
                        message.repliedTo!.author.userID == chatUser.userID,
                  ),
                ),
              if (showUserAvatarInChat &&
                  chatUser.userID != message.author.userID)
                Container(
                  // width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .003),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    "~${message.author.name != null && message.author.name!.isNotEmpty ? message.author.name : message.author.userID}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontStyle: FontStyle.italic,
                        color: createColorFromHashCode(
                                message.author.userID.hashCode)
                            .main),
                  ),
                ),
              Container(
                padding: showUserAvatarInChat &&
                        chatUser.userID != message.author.userID &&
                        message.type == MessageType.text
                    ? const EdgeInsets.only(
                        left: 15, right: 15, top: 3, bottom: 16)
                    : const EdgeInsets.all(0),
                child: ComputedMessage(
                  message: message,
                  isAuthor: message.author.userID == chatUser.userID,
                  customWidgetBuilder: customWidgetBuilder,
                  pdfWidgetBuilder: pdfWidgetBuilder,
                  videoWidgetBuilder: videoWidgetBuilder,
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
