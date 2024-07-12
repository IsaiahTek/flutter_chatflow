import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chatflow/chatflow.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/notifier.dart';
import 'package:flutter_chatflow/utils/types.dart'; //You can use our defined types or use yours. See documentation on avoiding type conflicts

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
              stream: FluChatNotifier.instance.isTypingStream,
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
        showUserAvatarInChat: true,
      ),
    );
  }
}
