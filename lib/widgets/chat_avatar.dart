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
    if(chatUser.photoUrl != null){
      if(chatUser.photoUrl!.isNotEmpty){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
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