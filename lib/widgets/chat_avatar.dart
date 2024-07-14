import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/utils.dart';

/// Chat Avatar. This could be profile photo
class ChatAvatar extends StatelessWidget {
  /// If set to true, all peers would have their avatar displayed.
  ///
  /// If no image url is provided in the `ChatUser` the the `userID` initial would be used
  final bool showUserAvatarInChat;

  /// ChatUser should at least have a `userID` and unique
  final ChatUser chatUser;

  /// Author is the sender of the message.
  final ChatUser author;

  /// Calling the constructor
  const ChatAvatar(
      {super.key,
      required this.author,
      required this.chatUser,
      required this.showUserAvatarInChat});

  /// check validity of the url
  bool get isValidUrl {
    if (hasPhoto) {
      final uri = Uri.tryParse(author.photoUrl!);
      bool result = uri != null &&
          (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.host.isNotEmpty;
      return result;
    } else {
      return false;
    }
  }

  /// check if the `ChatUser` has `photoUrl`
  bool get hasPhoto {
    String? photoUrl = author.photoUrl;
    return photoUrl != null && photoUrl.isNotEmpty;
  }

  /// Check if the user has name
  bool get hasName => author.name != null && author.name!.isNotEmpty;

  /// Compute the user avatar
  String get avatarText => hasName
      ? author.name!.substring(0, 1)
      : author.userID.toString().substring(0, 1);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        if (showUserAvatarInChat && chatUser.userID != author.userID)
          Container(
            margin: const EdgeInsets.only(left: 5),
            child: CircleAvatar(
                backgroundColor:
                    createColorFromHashCode(author.userID.hashCode).main,
                foregroundImage:
                    isValidUrl ? NetworkImage(author.photoUrl!) : null,
                child: Text(
                  avatarText,
                  style: TextStyle(
                      color: createColorFromHashCode(author.userID.hashCode)
                          .surface),
                )),
          ),
      ],
    );
  }
}
