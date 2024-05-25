import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/utils.dart';

class ChatAvatar extends StatelessWidget{
  final bool showUserAvatarInChat;
  final ChatUser chatUser;
  final ChatUser author;

  const ChatAvatar({super.key, 
    required this.author,
    required this.chatUser,
    required this.showUserAvatarInChat
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
        if(showUserAvatarInChat && chatUser.userID != author.userID)
        Container(
          margin: const EdgeInsets.only(left: 5),
          child: CircleAvatar(
            backgroundColor: createColorFromHashCode(author.userID.hashCode),
            child: hasPhoto
              ? Image.network(author.photoUrl!)
              : Text(avatarText)
          ),
        ),
      ],
    );
  }
}