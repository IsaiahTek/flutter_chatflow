import 'package:flutter_chatflow/utils/types.dart';

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

class ChatInfo extends Message{
  final String info;
  ChatInfo({
    super.type = MessageType.info,
    super.author = const ChatUser(userID: ''),
    required super.createdAt,
    required this.info
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