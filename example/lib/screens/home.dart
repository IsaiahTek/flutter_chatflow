import 'package:flutter/material.dart';
import 'package:flutter_chatflow/chatflow.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/types.dart';

class Home extends StatefulWidget{

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Message> messages = [];
  ChatUser john = const ChatUser(userID: "john");
  ChatUser jane = const ChatUser(userID: "jane");

  bool isJohn = true;

  void onSendPressed(String message){
    TextMessage textMessage = TextMessage(
      author: isJohn?john:jane,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      text: message,
      status: DeliveryStatus.sending
    );
    setState(() {
      messages.insert(0, textMessage);
      isJohn = !isJohn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
      body: ChatFlow(
        messages: messages,
        chatUser: john,
        onSendPressed: onSendPressed,
      ),
    );
  }
}