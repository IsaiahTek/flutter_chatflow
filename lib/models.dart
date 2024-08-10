import 'package:flutter_chatflow/utils/types.dart';

/// Base Message class and should'nt be used directly. Can be extended to create other message types

abstract class Message {
  /// Internal Message type. Must be one of the types in types file
  MessageType type;

  /// Message sender
  ChatUser author;

  /// Message ID
  String? messageID;

  /// Timestamp
  int createdAt;

  /// Delivery status could be any of the follow `sending, sent, delivered, read`
  DeliveryStatus? status;

  /// Store other details you need here.
  Map<String, dynamic>? meta;

  /// [Optional] The Message that `this` message is replied
  ///
  /// Ensure you pass this in if you want the reply to apply to the replied message.
  ///
  /// When a messsage is marked as a repliedTo message, ChatFlow will include it in the payload passed to either the onSendPressed or the onAttachmentPressed callback.
  Message? repliedTo;

  @override
  String toString() {
    return 'Message(message type: $type, author:${author.toString()}, status:$status, timestamp:$createdAt)';
  }

  ///Create the class
  Message(
      {required this.type,
      required this.author,
      required this.createdAt,
      this.messageID,
      this.status,
      this.meta,
      this.repliedTo});
}

/// Image message
class ImageMessage extends Message {
  /// uri/url or local file path
  String uri;

  /// [Optional] text
  String? text;

  /// Create
  ImageMessage({
    super.type = MessageType.image,
    required super.author,
    required super.createdAt,
    required this.uri,
    super.status,
    super.messageID,
    this.text,
    super.meta,
    super.repliedTo,
  });
}

/// Audio message
class AudioMessage extends Message {
  /// uri/url or local file path
  String uri;

  /// [Optional] text
  String? text;

  /// Create
  AudioMessage({
    super.type = MessageType.image,
    required super.author,
    required super.createdAt,
    required this.uri,
    this.text,
    super.status,
    super.messageID,
    super.meta,
    super.repliedTo,
  });
}

/// Video message
class VideoMessage extends Message {
  /// uri/url or local file path
  String uri;

  /// [Optional] text
  String? text;

  /// Create
  VideoMessage({
    super.type = MessageType.video,
    required super.author,
    required super.createdAt,
    required this.uri,
    this.text,
    super.status,
    super.messageID,
    super.meta,
    super.repliedTo,
  });
}

/// PDF
class PdfMessage extends Message {
  /// uri/url or local file path
  String uri;

  /// [Optional] text
  String? text;

  /// Create class
  PdfMessage({
    super.type = MessageType.pdf,
    required super.author,
    required super.createdAt,
    required this.uri,
    this.text,
    super.status,
    super.messageID,
    super.meta,
    super.repliedTo,
  });
}

/// PDF
class DocMessage extends Message {
  /// uri/url or local file path
  String uri;

  /// [Optional] text
  String? text;

  /// Create class
  DocMessage({
    super.type = MessageType.doc,
    required super.author,
    required super.createdAt,
    required this.uri,
    this.text,
    super.status,
    super.messageID,
    super.meta,
    super.repliedTo,
  });
}

/// PDF
class FileMessage extends Message {
  /// uri/url or local file path
  String uri;

  /// [Optional] text
  String? text;

  /// Create class
  FileMessage({
    super.type = MessageType.file,
    required super.author,
    required super.createdAt,
    required this.uri,
    this.text,
    super.status,
    super.messageID,
    super.meta,
    super.repliedTo,
  });
}

/// PDF
class CustomMessage extends Message {
  /// uri/url or local file path
  final dynamic custom;

  /// [Optional] text
  String? text;

  /// Create class
  CustomMessage({
    super.type = MessageType.custom,
    required super.author,
    required super.createdAt,
    this.custom,
    this.text,
    super.status,
    super.messageID,
    super.meta,
    super.repliedTo,
  });
}

/// Text message
class TextMessage extends Message {
  /// Message text
  final String text;

  /// Create the class
  TextMessage(
      {super.type = MessageType.text,
      required super.author,
      required super.createdAt,
      required this.text,
      super.status,
      super.messageID,
      super.repliedTo});
}

/// Chat info could be anything like announcement or in-chat notification
class ChatInfo extends Message {
  /// Text information
  final String info;

  /// Create the class
  ChatInfo(
      {super.type = MessageType.info,
      super.author = const ChatUser(userID: ''),
      super.messageID,
      required super.createdAt,
      required this.info});
}

/// Chat User
class ChatUser {
  /// Unique for identifying each user in chat
  final String userID;

  /// Name
  final String? name;

  /// Photo url on server
  final String? photoUrl;

  /// Create user
  const ChatUser({required this.userID, this.name, this.photoUrl});
}
