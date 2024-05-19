import 'package:flutter/material.dart';
import 'package:flutter_chatflow/notifier.dart';
import 'package:flutter_chatflow/widgets/computed_widget.dart';
import 'package:flutter_chatflow/widgets/image_carousel.dart';

enum MessageType{
  text,
  image,
  video,
  file,
  custom,
  partition
}

abstract class Message{
  MessageType type;
  String authorID;
  int createdAt;
  Map<String, dynamic>? meta;

  Message({
    required this.type,
    required this.authorID,
    required this.createdAt,
    this.meta
  });
}

class ImageMessage extends Message{
  final String uri;
  String? text;
  ImageMessage({
    super.type = MessageType.image,
    required super.authorID,
    required super.createdAt,
    required this.uri,
    this.text
  });
}

class PartitionMessage extends Message{
  PartitionMessage({
    required super.authorID,
    required super.createdAt,
    super.type = MessageType.partition
  });
}

class TextMessage extends Message{
  final String text;
  TextMessage({
    super.type = MessageType.text,
    required super.authorID,
    required super.createdAt,
    required this.text
  });
}

class FluChat extends StatefulWidget{
  
  final List<Message> messages;
  final String userID;
  final void Function(String message)? onSendPressed;
  final void Function()? onAttachmentPressed;
  
  const FluChat({
    super.key,
    required this.messages,
    required this.userID,
    this.onSendPressed,
    this.onAttachmentPressed,
  });

  @override
  State<StatefulWidget> createState() => _FluChatState();

}

class _FluChatState extends State<FluChat>{

  final TextEditingController _textEditingController = TextEditingController();

  bool isSameDay(int? previousMessageTime, int currentMessageTime){
    return previousMessageTime != null 
      ? DateTime.fromMillisecondsSinceEpoch(currentMessageTime).difference(DateTime.fromMillisecondsSinceEpoch(previousMessageTime)).inDays != 0
      : true;
  }

  List<Message> get _messages => widget.messages..sort((a, b)=> a.createdAt.compareTo(b.createdAt));
    

  String computeTimePartitionText(int millisecondsSinceEpoch){
    int year = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch).year;
    int month = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch).month;
    int day = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch).day;
    return '$day/$month/$year';
  }

  // Passed to image carousel for viewing all images in current chat
  List<ImageMessage> get _imageMessages => _messages.where((element) => element.type == MessageType.image).cast<ImageMessage>().toList();

  @override
  void initState() {
    _textEditingController.addListener(() {
      FluChatNotifier.instance.setIsTyping();
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
                      return Column(
                        children: [
                          if(isSameDay( index > 0 ? _messages[index-1].createdAt: null, _messages[index].createdAt))
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(color: Colors.white10),
                                child: Text(
                                  computeTimePartitionText(_messages[index].createdAt),
                                  style: const TextStyle(fontStyle: FontStyle.italic),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: widget.userID == _messages[index].authorID ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints.loose(Size.fromWidth(MediaQuery.of(context).size.width*.75)),
                                child: GestureDetector(
                                  onTap: (){
                                    debugPrint("Taped message");
                                    int currentImageIndex = _imageMessages.indexWhere((element) => element.createdAt == _messages[index].createdAt);
                                    if(_messages[index].type == MessageType.image){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: ((context) => ImageCarousel(imageMessages: _imageMessages, currentIndex: currentImageIndex,))
                                        )
                                      );
                                    }
                                  },
                                  onLongPress: ()=>debugPrint("Long Press message"),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: widget.userID == _messages[index].authorID ? Theme.of(context).primaryColor.withOpacity(.2) : const Color.fromARGB(255, 241, 241, 241),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: _messages[index].type == MessageType.text ? 15 : 2, vertical: _messages[index].type == MessageType.text ? 10 : 2),
                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    child: ComputedMessage(message: _messages[index]),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      );
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