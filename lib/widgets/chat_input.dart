import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/notifier.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/widgets/replied_message_widget.dart';

/// Not for your usage
class ChatInputWidget extends StatefulWidget {
  /// Internal use only.
  const ChatInputWidget(
      {super.key,
      required this.onSendPressed,
      required this.onAttachmentPressed,
      this.replyMessage,
      this.unsetReplyMessage});

  /// The callback to handle the event when a user sends a text message.
  final OnSendPressed onSendPressed;

  /// The callback for handling attachment button click.
  final void Function()? onAttachmentPressed;

  /// The swiped message to be replied to
  final Message? replyMessage;

  /// Internal Callback to unset reply message
  final void Function()? unsetReplyMessage;

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _textEditingController = TextEditingController();
  late bool textIsNotEmpty;
  final FocusNode textInputFocusNode = FocusNode();

  @override
  initState() {
    textIsNotEmpty = _textEditingController.text.isNotEmpty;
    _textEditingController.addListener(() {
      if (textInputFocusNode.hasFocus) {
        FluChatNotifier.instance.setIsTyping();
      }
      setState(() {
        textIsNotEmpty = _textEditingController.text.isNotEmpty;
      });
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.replyMessage != null)
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: RepliedMessageWidget(replyMessage: widget.replyMessage!),
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    height: 20,
                    width: 20,
                    margin: const EdgeInsets.only(top: 5, right: 5),
                    child: GestureDetector(
                      onTap: widget.unsetReplyMessage,
                      child: const Icon(
                        Icons.close,
                        size: 18,
                      ),
                    ),
                  ))
            ],
          ),
        ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: widget.replyMessage == null
                    ? const Radius.circular(30)
                    : const Radius.circular(0),
                topRight: widget.replyMessage == null
                    ? const Radius.circular(30)
                    : const Radius.circular(0),
                bottomLeft: const Radius.circular(30),
                bottomRight: const Radius.circular(30)),
            child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
                margin: const EdgeInsets.all(2),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).primaryColor),
                child: Row(
                  children: [
                    if (widget.onAttachmentPressed != null)
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
                      focusNode: textInputFocusNode,
                      // onChanged: (e) {
                      //   FluChatNotifier.instance.setIsTyping();
                      // },
                    )),
                    if (textIsNotEmpty)
                      IconButton.filledTonal(
                        onPressed: () {
                          // try {
                          widget.onSendPressed != null
                              ? widget.onSendPressed!(
                                  _textEditingController.text,
                                  repliedTo: widget.replyMessage)
                              : null;
                          // } catch (e) {
                          //   logError("Error on onSendPressed: $e");
                          // }
                          _textEditingController.clear();
                          if (widget.unsetReplyMessage != null) {
                            widget.unsetReplyMessage!();
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                  ],
                ))),
      ],
    );
  }
}
