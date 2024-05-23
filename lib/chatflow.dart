import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chatflow/notifier.dart';
import 'package:flutter_chatflow/utils.dart';
import 'package:flutter_chatflow/widgets/chat_avatar.dart';
import 'package:flutter_chatflow/widgets/chat_bubble.dart';
import 'package:flutter_chatflow/widgets/computed_widget.dart';
import 'package:flutter_chatflow/widgets/image/image_carousel.dart';

enum MessageType{
  text,
  image,
  audio,
  video,
  pdf,
  doc,
  file,
  custom
}

abstract class Message{
  MessageType type;
  ChatUser author;
  int createdAt;
  Map<String, dynamic>? meta;

  Message({
    required this.type,
    required this.author,
    required this.createdAt,
    this.meta
  });
}

class ImageMessage extends Message{
  final String uri;
  String? text;
  ImageMessage({
    super.type = MessageType.image,
    required super.author,
    required super.createdAt,
    required this.uri,
    this.text,
    super.meta,
  });
}

class AudioMessage extends Message{
  final String uri;
  String? text;
  AudioMessage({
    super.type = MessageType.image,
    required super.author,
    required super.createdAt,
    required this.uri,
    this.text,
    super.meta,
  });
}

class VideoMessage extends Message{
  final String uri;
  String? text;
  VideoMessage({
    super.type = MessageType.video,
    required super.author,
    required super.createdAt,
    required this.uri,
    this.text,
    super.meta,
  });
  
}

class PdfMessage extends Message{
  final String uri;
  String? text;
  PdfMessage({
    super.type = MessageType.video,
    required super.author,
    required super.createdAt,
    required this.uri,
    this.text,
    super.meta,
  });
  
}

class TextMessage extends Message{
  final String text;
  TextMessage({
    super.type = MessageType.text,
    required super.author,
    required super.createdAt,
    required this.text
  });
}

class ChatUser{
  final String userID;
  final String? name;
  final String? photoUrl;

  const ChatUser({
    required this.userID,
    this.name,
    this.photoUrl
  });
}

class ChatFlow extends StatefulWidget{
  
  final List<Message> messages;
  final ChatUser chatUser;
  final void Function(String message)? onSendPressed;
  final void Function()? onAttachmentPressed;
  final void Function()? onMessageLongPressed;
  final void Function()? onMessageSwipedLeft;
  final void Function()? onMessageSwipedRight;
  final bool? showUserAvatarInChat; // Used to show user photo or name initial in group chat
  final Theme? theme;
  
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
    this.theme
  });

  @override
  State<StatefulWidget> createState() => _FluChatState();

}

class _FluChatState extends State<ChatFlow>{

  final TextEditingController _textEditingController = TextEditingController();

  List<Message> get _messages => widget.messages..sort((a, b)=> a.createdAt.compareTo(b.createdAt));

  bool showUserAvatarInChat = false;



  // Passed to image carousel for viewing all images in current chat
  List<ImageMessage> get _imageMessages => _messages.where((element) => element.type == MessageType.image).cast<ImageMessage>().toList();

  @override
  void initState() {
    _textEditingController.addListener(() {
      FluChatNotifier.instance.setIsTyping();
    });
    setState(() {
      showUserAvatarInChat = widget.showUserAvatarInChat??false;
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
      child: Column(
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
                    itemBuilder: (context, index){
                      return ChatBubble(message: _messages[index], chatUser: widget.chatUser, imageMessages: _imageMessages, showUserAvatarInChat: showUserAvatarInChat, previousMessageCreatedAt: index>1?_messages[index-1].createdAt:null);
                    }
                  ),
                ],
              ),
            )
          ),

          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Theme.of(context).primaryColor
            ),
            child: Row(
              children: [
                IconButton.filledTonal(
                  onPressed: (){
                    if(widget.onAttachmentPressed != null){
                      widget.onAttachmentPressed!();
                    }
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10,),
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
                  )
                ),
                IconButton.filledTonal(
                  onPressed: (){
                    widget.onSendPressed != null ? widget.onSendPressed!(_textEditingController.text) : null;
                    _textEditingController.clear();
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}