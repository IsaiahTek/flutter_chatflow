import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chatflow/event_manager.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/utils/utils.dart';
import 'package:flutter_chatflow/widgets/chat_bubble.dart';
import 'library.dart';
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

  /// The callback when the user presses down a message for long.
  ///
  /// By default, the message is selected.
  ///
  /// Example of how to intercept the default gesture event on message.
  ///
  /// Calling the second argument `defaultAction` implements the default action together with your custom action.
  /// Sample code below
  /// ```dart
  /// ChatFlow(
  ///   messages: messages,
  ///   chatUser: chatUsers,
  ///   onSendPressed: onSendPressed,
  ///   onAttachmentPressed: _handleImageSelection,
  ///   onMessageLongPressed: (Message message, Function(Message message) defaultAction) {
  ///     debugPrint("Here is the message long pressed $message");
  ///     defaultAction(message);
  ///   },
  ///   onMessageSelectionChanged: _handleMessageSelectionChange,
  /// ),
  /// ```
  /// In the example we executed a custom code before calling the default action which is to select the message.
  ///
  /// Feel free to use it as you want!
  final OnMessageGesture? onMessageLongPressed;

  /// The callback when the user presses down a message for long. By default, the message is selected.
  final void Function(Message message)? onMessageDoubleTaped;

  /// Callback for when a message is swiped left
  final void Function(Message swipedMessage)? onMessageSwipedLeft;

  /// Callback for when a message is swiped right
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

  /// Option for hiding ChatFlow default input widget.
  ///
  /// ChatFlow default input widget contains basically 3 other widgets:
  ///   1. TextField
  ///   2. Send Button
  ///   3. Attachment Button
  ///
  /// Developers might want to use custom input widget for better controls. Just pass in the
  /// `hideDefaultInputWidget:true`
  ///
  /// Default: `final hideDefaultInputWidget = false`;
  final bool? hideDefaultInputWidget;

  /// ChatFlow used to add chat features to the app
  const ChatFlow(
      {super.key,
      required this.messages,
      required this.chatUser,
      this.onSendPressed,
      this.onAttachmentPressed,
      this.onMessageLongPressed,
      this.onMessageDoubleTaped,
      this.onMessageSwipedLeft,
      this.onMessageSwipedRight,
      this.showUserAvatarInChat,
      this.onMessageSelectionChanged,
      this.theme,
      this.videoWidgetBuilder,
      this.pdfWidgetBuilder,
      this.customWidgetBuilder,
      this.shouldGroupConsecutiveImages,
      this.minImagesToGroup,
      this.hideDefaultInputWidget = false});

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

  _handleSetSelectedMessage(List<Message> list) {
    if (widget.onMessageSelectionChanged != null) {
      setState(() {
        selectedMessages = list;
      });
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
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                reverse: false,
                itemCount: _messages.length,
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: (indexIsInConsecutivesAndIsFirstTake(
                            groupedImages, index))
                        ? Column(
                            children: [
                              _TimePartitionText(
                                  createdAt: _messages[index].createdAt,
                                  previousMessageCreatedAt:
                                      _messages[index - 1].createdAt),
                              if (_messages[index].type == MessageType.info)
                                _InfoMessage(message: _messages[index]),
                              GroupedImages(
                                images: getGroupedImageMessages(
                                    _messages, groupedImages, index),
                                chatUser: widget.chatUser,
                                isGroupChat:
                                    widget.showUserAvatarInChat ?? false,
                              ),
                            ],
                          )
                        : (indexIsInConsecutives(groupedImages, index))
                            ? const SizedBox.shrink()
                            : ChatBubble(
                                message: _messages[index],
                                chatUser: widget.chatUser,
                                imageMessages: _imageMessages,
                                onLongPressed: widget.onMessageLongPressed,
                                showUserAvatarInChat: showUserAvatarInChat,
                                previousMessageCreatedAt: index > 0
                                    ? _messages[index - 1].createdAt
                                    : null,
                                currentMessageIndex: index,
                                setReplyMessage: handleSetReplyMessage,
                                setSelectedMessages:
                                    _handleSetSelectedMessage,
                                selectedMessages: selectedMessages,
                                videoWidgetBuilder:
                                    widget.videoWidgetBuilder,
                                pdfWidgetBuilder: widget.pdfWidgetBuilder,
                                customWidgetBuilder:
                                    widget.customWidgetBuilder,
                              ),
                  );
                }
                // }
                )),
        if (!(widget.hideDefaultInputWidget ?? false))
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
    );
  }
}

/// Use this class' static members to trigger functions in your code that you want to ChatFlow to handle
class ChatFlowEvent {
  /// Used when closing/exiting selected messages
  static void unselectAllMessages() {
    EventManager.instance.unselectAllMessages();
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
