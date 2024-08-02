import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chatflow/chatflow.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/notifier.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/widgets/image/image_upload_preview_with_text_input.dart';
import 'package:flutter_chatflow/widgets/media_selection_with_text.dart';
import 'package:image_picker/image_picker.dart'; //You can use our defined types or use yours. See documentation on avoiding type conflicts

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Message> messages = [];
  ChatUser john = const ChatUser(userID: "john");
  ChatUser jane = const ChatUser(userID: "jane");
  ChatUser faith = const ChatUser(userID: "Matthew");
  ChatUser jerry = const ChatUser(userID: "Saturday");
  ChatUser mark = const ChatUser(userID: "Zackaxorphy");

  List<ChatUser> get users => [john, jane, faith, jerry, mark];

  bool isJohn = true;

  final ImagePicker _picker = ImagePicker();

  void onSendPressed(String message, {Message? repliedTo}) {
    TextMessage textMessage = TextMessage(
        author: users[(Random().nextDouble() * 5)
            .toInt()], // Switching author for testing
        createdAt: DateTime.now().millisecondsSinceEpoch,
        text: message,
        repliedTo: repliedTo,
        status: DeliveryStatus.sending);
    setState(() {
      messages.insert(0, textMessage);
      isJohn = !isJohn; // Toggle the sender/author for testing
    });
  }

  void _handleImageSelection({Message? repliedTo}) async {
    try {
      final results = await _picker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 1440,
      );

      handleSetSelectionWithText(
          List<MediaSelectionWithText> selectionWithText) {
        if (selectionWithText.isNotEmpty) {
          // final bytes = await result.readAsBytes();
          // final image = await decodeImageFromList(bytes);

          for (var element in selectionWithText) {
            int createdAt = DateTime.now().millisecondsSinceEpoch;
            final message = ImageMessage(
                author: users[(Random().nextDouble() * 5).toInt()],
                createdAt: createdAt,
                repliedTo: repliedTo,
                uri: element.uri,
                text: element.text);

            messages.insert(0, message);
          }
        }
      }

      //
      if (mounted && results.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageUploadPreviewWithTextInput(
                      imagesUri: results.map((e) => e.path).toList(),
                      setMediaSelectionsWithText: handleSetSelectionWithText,
                    )));
      }
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
          leadingWidth: 100,
          leading: Text(
            "ChatFlow",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize),
          ),
          title: StreamBuilder(
              stream: UserTypingStateStream.instance.isTypingStream,
              builder: (context, data) {
                if (data.hasData && data.data == true) {
                  return const Text('Typing');
                } else {
                  return const SizedBox.shrink();
                }
              })),
      body: ChatFlow(
        messages: messages,
        chatUser: john,
        onSendPressed: onSendPressed,
        onAttachmentPressed: _handleImageSelection,
        onMessageLongPressed: (message, defaultAction) {
          debugPrint("Here is the message long pressed $message");
          // defaultAction(message);
        },
        showUserAvatarInChat: true,
      ),
    );
  }
}
