import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/notifier.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/widgets/chat_bubble.dart';

/// Entry point to using the ChatFlow.
class ChatFlow extends StatefulWidget {
  /// The messages to be shown in the chat
  final List<Message> messages;

  /// The current user of the chat. Ensure the `[userID]` is unique.
  final ChatUser chatUser;

  /// The callback to handle the event when a user sends a text message.
  final void Function(String message)? onSendPressed;

  /// The callback for handling attachment button click.
  final void Function()? onAttachmentPressed;

  /// The callback when the user presses down a message for long. By default, the message is selected
  final void Function()? onMessageLongPressed;

  /// Callback for when a message is swiped left
  final void Function()? onMessageSwipedLeft;

  /// Callback for when a message is swiped right
  final void Function()? onMessageSwipedRight;

  /// Set this as true if you want peer user avatar/profile photo to be shown in chat. This is typically used in group chat
  final bool? showUserAvatarInChat;

  /// Callback to handle the user delete button click after selecting a message
  final void Function(List<Message> messages)? onDeleteMessages;
  final Theme? theme;

  /// Widget for custom message
  final CustomWidgetBuilder? customWidgetBuilder;

  /// Widget for video message. ChatFlow does not create this widget as we focus on chat management and try to avoid conflicts with your preference
  final CustomWidgetBuilder? videoWidgetBuilder;

  /// Widget for displaying pdf files
  final CustomWidgetBuilder? pdfWidgetBuilder;

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
  final TextEditingController _textEditingController = TextEditingController();

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
    _textEditingController.addListener(() {
      FluChatNotifier.instance.setIsTyping();
    });
    setState(() {
      showUserAvatarInChat = widget.showUserAvatarInChat ?? false;
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: _messages.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ChatBubble(
                            message: _messages[index],
                            chatUser: widget.chatUser,
                            imageMessages: _imageMessages,
                            showUserAvatarInChat: showUserAvatarInChat,
                            previousMessageCreatedAt: index > 0
                                ? _messages[index - 1].createdAt
                                : null,
                            currentMessageIndex: index,
                            setSelectedMessages: handleSetSelectedMessage,
                            selectedMessages: selectedMessages,
                            videoWidgetBuilder: widget.videoWidgetBuilder,
                            pdfWidgetBuilder: widget.pdfWidgetBuilder,
                            customWidgetBuilder: widget.customWidgetBuilder,
                          );
                        }),
                  ],
                ),
              )),
              Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor),
                  child: Row(
                    children: [
                      IconButton.filledTonal(
                        onPressed: () {
                          if (widget.onAttachmentPressed != null) {
                            widget.onAttachmentPressed!();
                          }
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Start typing",
                          border: InputBorder.none,
                        ),
                        maxLines: 3,
                        minLines: 1,
                        style: const TextStyle(color: Colors.white),
                        controller: _textEditingController,
                        onChanged: (e) {
                          FluChatNotifier.instance.setIsTyping();
                        },
                      )),
                      IconButton.filledTonal(
                        onPressed: () {
                          widget.onSendPressed != null
                              ? widget
                                  .onSendPressed!(_textEditingController.text)
                              : null;
                          _textEditingController.clear();
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  )),
            ],
          ),
          if (selectedMessages.isNotEmpty)
            Positioned(
              top: 5,
              // left: 5,
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
        ],
      ),
    );
  }
}
