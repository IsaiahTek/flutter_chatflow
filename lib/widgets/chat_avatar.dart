import 'package:flutter/material.dart';
import 'package:flutter_chatflow/chatflow.dart';

class ChatAvatar extends StatelessWidget{
  final bool isGroupChat;
  final ChatUser chatUser;
  final ChatUser author;

  const ChatAvatar({super.key, 
    required this.author,
    required this.chatUser,
    required this.isGroupChat
  });

  bool get hasPhoto {
    String? photoUrl = chatUser.photoUrl;
    return photoUrl != null && photoUrl.isNotEmpty;
  }

  bool get hasName => chatUser.name != null;
  String get avatarText => hasName?author.name!.substring(0,1):author.userID.substring(0,1);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        if(isGroupChat && chatUser.userID != author.userID)
        CircleAvatar(
          child: hasPhoto
            ? Image.network(author.photoUrl!)
            : Text(avatarText)
        ),
      ],
    );
  }
}