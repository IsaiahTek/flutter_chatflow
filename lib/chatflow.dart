import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/widgets/chat_bubble.dart';
import 'package:flutter_chatflow/widgets/chat_input.dart';

/// Entry point to using the ChatFlow.
class ChatFlow extends StatefulWidget {
  /// The messages to be shown in the chat
  final List<Message> messages;

  /// The current user of the chat. Ensure the `[userID]` is unique.
  final ChatUser chatUser;

  /// The callback to handle the event when a user sends a text message.
  final void Function(String message, {Message? repliedTo})? onSendPressed;

  /// The callback for handling attachment button click.
  final void Function()? onAttachmentPressed;

  /// The callback when the user presses down a message for long. By default, the message is selected
  final void Function()? onMessageLongPressed;

  /// Callback for when a message is swiped _left
  final void Function(Message swipedMessage)? onMessageSwipedLeft;

  /// Callback for when a message is swiped _right
  final void Function(Message swipedMessage)? onMessageSwipedRight;

  /// Set this as true if you want peer user avatar/profile photo to be shown in chat. This is typically used in group chat
  final bool? showUserAvatarInChat;

  /// Callback to handle the user delete button click after selecting a message
  final void Function(List<Message> messages)? onDeleteMessages;

  /// Theme for customaziation
  final Theme? theme;

  /// Widget for custom message
  final CustomWidgetBuilder? customWidgetBuilder;

  /// Widget for video message. ChatFlow does not create this widget as we focus on chat management and try to avoid conflicts with your preference
  final CustomWidgetBuilder? videoWidgetBuilder;

  /// Widget for displaying pdf files
  final CustomWidgetBuilder? pdfWidgetBuilder;

  /// ChatFlow used to add chat features to the app
  const ChatFlow({
    super.key,
    required this.messages,
    required this.chatUser,
    this.onSendPressed,
    this.onAttachmentPressed,
    this.onMessageLongPressed,
    this.onMessageSwipedLeft,
    this.onMessageSwipedRight,
    this.showUserAvatarInChat,
    this.onDeleteMessages,
    this.theme,
    this.videoWidgetBuilder,
    this.pdfWidgetBuilder,
    this.customWidgetBuilder,
  });

  @override
  State<StatefulWidget> createState() => _ChatFlowState();
}

class _ChatFlowState extends State<ChatFlow> {
  Message? replyMessage;

  List<Message> get _messages =>
      widget.messages..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  bool showUserAvatarInChat = false;

  // Passed to image carousel for viewing all images in current chat
  List<ImageMessage> get _imageMessages => _messages
      .where((element) => element.type == MessageType.image)
      .cast<ImageMessage>()
      .toList();

  List<Message> selectedMessages = [];

  handleSetSelectedMessage(List<Message> list) {
    setState(() {
      selectedMessages = list;
    });
  }

  @override
  void initState() {
    setState(() {
      showUserAvatarInChat = widget.showUserAvatarInChat ?? false;
    });
    super.initState();
  }

  void handleSetReplyMessage(Message reply) {
    setState(() {
      replyMessage = reply;
    });
  }

  void handleUnsetReplyMessage() {
    setState(() {
      replyMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(children: [
          Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: _messages.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(bottom: 20),
                            child: ChatBubble(
                              message: _messages[index],
                              chatUser: widget.chatUser,
                              imageMessages: _imageMessages,
                              showUserAvatarInChat: showUserAvatarInChat,
                              previousMessageCreatedAt: index > 0
                                  ? _messages[index - 1].createdAt
                                  : null,
                              currentMessageIndex: index,
                              setReplyMessage: handleSetReplyMessage,
                              setSelectedMessages: handleSetSelectedMessage,
                              selectedMessages: selectedMessages,
                              videoWidgetBuilder: widget.videoWidgetBuilder,
                              pdfWidgetBuilder: widget.pdfWidgetBuilder,
                              customWidgetBuilder: widget.customWidgetBuilder,
                            ),
                          );
                        }),
                  ],
                ),
              )),
              Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                margin: EdgeInsets.only(bottom: Platform.isIOS ? 30 : 0),
                child: ChatInputWidget(
                  onSendPressed: widget.onSendPressed,
                  onAttachmentPressed: widget.onAttachmentPressed,
                  replyMessage: replyMessage,
                  unsetReplyMessage: handleUnsetReplyMessage,
                ),
              )
            ],
          ),
          // /Widget for showing controls when messages are selected
          if (selectedMessages.isNotEmpty)
            Positioned(
              top: 5,
              // _left: 5,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(offset: Offset(0, .5))]),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                // margin: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            selectedMessages = [];
                          });
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.black54,
                        )),
                    IconButton(
                        onPressed: () {
                          if (widget.onDeleteMessages != null) {
                            widget.onDeleteMessages!(selectedMessages);
                            setState(() {
                              selectedMessages = [];
                            });
                          }
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).primaryColor,
                        )),
                  ],
                ),
              ),
            ),
        ]));
  }
}
