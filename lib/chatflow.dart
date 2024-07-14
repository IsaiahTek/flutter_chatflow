import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chatflow/event_manager.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/utils/utils.dart';
import 'package:flutter_chatflow/widgets/chat_bubble.dart';
import 'package:flutter_chatflow/widgets/chat_input.dart';
import 'package:flutter_chatflow/widgets/image/grouped_images.dart';

/// Entry point to using the ChatFlow.
class ChatFlow extends StatefulWidget {
  /// The messages to be shown in the chat
  final List<Message> messages;

  /// The current user of the chat. Ensure the `[userID]` is unique.
  final ChatUser chatUser;

  /// The callback to handle the event when a user sends a text message.
  final OnSendPressed onSendPressed;

  /// The callback for handling attachment button click.
  final OnAttachmentPressed onAttachmentPressed;

  /// The callback when the user presses down a message for long. By default, the message is selected
  final void Function()? onMessageLongPressed;

  /// Callback for when a message is swiped _left
  final void Function(Message swipedMessage)? onMessageSwipedLeft;

  /// Callback for when a message is swiped _right
  final void Function(Message swipedMessage)? onMessageSwipedRight;

  /// Set this as true if you want peer user avatar/profile photo to be shown in chat. This is typically used in group chat
  final bool? showUserAvatarInChat;

  /// Callback to handle the user delete button click after selecting a message
  final void Function(List<Message> messages)? onMessageSelectionChanged;

  /// [Optional] Defaults to true. If you don't want to group consecutive images just make it false
  final bool? shouldGroupConsecutiveImages;

  /// [Optional] By the default, if consecutive images are upto 4 or more by the same author and on the same day, these images would be grouped.
  ///
  /// Change this value if you want it to be other amount greater than 4. It can't be less that 4
  final int? minImagesToGroup;

  /// Theme for customaziation
  final Theme? theme;

  /// Widget for custom message
  final CustomWidgetBuilder? customWidgetBuilder;

  /// Widget for video message. ChatFlow does not create this widget as we focus on chat management and try to avoid conflicts with your preference
  final CustomWidgetBuilder? videoWidgetBuilder;

  /// Widget for displaying pdf files
  final CustomWidgetBuilder? pdfWidgetBuilder;

  /// ChatFlow used to add chat features to the app
  const ChatFlow(
      {super.key,
      required this.messages,
      required this.chatUser,
      this.onSendPressed,
      this.onAttachmentPressed,
      this.onMessageLongPressed,
      this.onMessageSwipedLeft,
      this.onMessageSwipedRight,
      this.showUserAvatarInChat,
      this.onMessageSelectionChanged,
      this.theme,
      this.videoWidgetBuilder,
      this.pdfWidgetBuilder,
      this.customWidgetBuilder,
      this.shouldGroupConsecutiveImages,
      this.minImagesToGroup});

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

  clearSelectedMessages() {
    setState(() {
      selectedMessages = [];
    });
  }

  handleSetSelectedMessage(List<Message> list) {
    setState(() {
      selectedMessages = list;
    });
    if (widget.onMessageSelectionChanged != null) {
      widget.onMessageSelectionChanged!(list);
    }
  }

  _handleUnselectAllMessages() {
    selectedMessages = [];
  }

  @override
  void initState() {
    setState(() {
      showUserAvatarInChat = widget.showUserAvatarInChat ?? false;
    });
    EventManager.instance.addListener(_handleUnselectAllMessages);
    super.initState();
  }

  @override
  void dispose() {
    EventManager.instance.removeListener(_handleUnselectAllMessages);
    super.dispose();
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
    List<ConsecutiveOccurrence> groupedImages =
        (widget.shouldGroupConsecutiveImages ?? true)
            ? getConsecutives(
                items: _messages,
                check: ImageMessage(
                    author: const ChatUser(userID: "userID"),
                    createdAt: 0,
                    uri: "uri"),
                amount: (widget.minImagesToGroup != null &&
                        widget.minImagesToGroup! > 3)
                    ? widget.minImagesToGroup
                    : 4)
            : [];
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
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: (indexIsInConsecutivesAndIsFirstTake(
                                    groupedImages, index))
                                ? GroupedImages(
                                    images: getGroupedImageMessages(
                                        _messages, groupedImages, index),
                                    chatUser: widget.chatUser,
                                  )
                                : (indexIsInConsecutives(groupedImages, index))
                                    ? const SizedBox.shrink()
                                    : ChatBubble(
                                        message: _messages[index],
                                        chatUser: widget.chatUser,
                                        imageMessages: _imageMessages,
                                        showUserAvatarInChat:
                                            showUserAvatarInChat,
                                        previousMessageCreatedAt: index > 0
                                            ? _messages[index - 1].createdAt
                                            : null,
                                        currentMessageIndex: index,
                                        setReplyMessage: handleSetReplyMessage,
                                        setSelectedMessages:
                                            handleSetSelectedMessage,
                                        selectedMessages: selectedMessages,
                                        videoWidgetBuilder:
                                            widget.videoWidgetBuilder,
                                        pdfWidgetBuilder:
                                            widget.pdfWidgetBuilder,
                                        customWidgetBuilder:
                                            widget.customWidgetBuilder,
                                      ),
                          );
                        }
                        // }
                        ),
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
                  pdfWidgetBuilder: widget.pdfWidgetBuilder,
                  customWidgetBuilder: widget.customWidgetBuilder,
                  videoWidgetBuilder: widget.videoWidgetBuilder,
                  isAuthor:
                      widget.chatUser.userID == replyMessage?.author.userID,
                  unsetReplyMessage: handleUnsetReplyMessage,
                ),
              )
            ],
          ),
        ]));
  }
}

/// Use this class' static members to trigger functions in your code that you want to ChatFlow to handle
class ChatFlowEvent {
  /// Used when closing/exiting selected messages
  static void unselectAllMessages() {
    EventManager.instance.unselectAllMessages();
  }
}
