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

  bool get isValidUrl {
    if(hasPhoto){
      final uri = Uri.tryParse(author.photoUrl!);
      bool result = uri != null && (uri.scheme == 'http' || uri.scheme == 'https') && uri.host.isNotEmpty;
      return result;
    }else{
      return false;
    }
  }

  bool get hasPhoto {
    String? photoUrl = author.photoUrl;
    return photoUrl != null && photoUrl.isNotEmpty;
  }

  bool get hasName => author.name != null;
  String get avatarText => hasName?author.name!.substring(0,1):author.userID.substring(0,1);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        if(showUserAvatarInChat && chatUser.userID != author.userID)
        Container(
          margin: const EdgeInsets.only(left: 5),
          child: CircleAvatar(
            // backgroundColor: createColorFromHashCode(author.userID.hashCode),
            child: isValidUrl
              ? Image.network(author.photoUrl!, errorBuilder: (context, error, stackTrace) {
                logError("Photo URL ERROR: $error");
                return Text(author.photoUrl.toString());
              },)
              : Text(avatarText)
          ),
        ),
      ],
    );
  }
}