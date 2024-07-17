<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->
<br>

<p align="center">
  <img src="https://raw.githubusercontent.com/IsaiahTek/flutter_chatflow/main/images/ChatFlow_banner.png" width="288px" alt="ChatFlow Logo" />
</p>
<p align="center">Fast and flexibile chat package with full features for easy app development. Actively maintained, community-driven chat UI implementation</p>

<p align="center">
  <img alt="Chat Image" src="https://raw.githubusercontent.com/IsaiahTek/flutter_chatflow/main/images/chatflow_featured2_v1.0.0.png" />
</p>
A powerful and flexible chat solution for Flutter apps. Features include real-time messaging, private chats, group chats, customizable UI, user management, media sharing, rich text support, typing user(s), etc.

## Features

1. Fast Messaging: The UI updates instantly as soon as it receives a new data. The developing sees to how the application stores the messages and it passes the same messages to the ChatFlow component for either private chats or group chats.
2. Customizable UI: Easily customizable chat themes, use builders to create more customized UI and layouts to match your app’s design.
3. User Management: Support for user authentication and profile management.
4. Media Sharing: Send and receive images, videos, and other media files.
5. Group Chats: Create and manage group conversations effortlessly.
6. Generic Media Type: Aside from the default message types which include Text, Image, Info, Audio, Video, PDF, Doc and File, there's a Custom type for you to extend and do more just in case the already available types aren't enough which we believe should be enough for most use cases.
7. Typing User: Listen to user typing events and do what you want such as notifying other users in the chat about that event.
8. Media Preview: By default, chatflow automatically shows images preview when a user taps on an image message. [See image above]
9. Select Message: A user can select message(s) in the chat. You get the list of selected message(s) and do what you want by providing a callback. [See API in Documentation]
10. Message Reply: Messages can be replied to easily. This makes your app more intuitive, modern and engaging.
<!-- 6. Rich Text Support: Emoji, links, and formatted text in messages. -->
Etc.

## Getting started

To get started with flutter_chatflow, check out the documentation for installation instructions, usage guides, and examples.

### Installation

Easiest way is to run the `flutter pub add flutter_chatflow`

Or
Add flutter_chatflow to your pubspec.yaml:
```yaml
dependencies:
  flutter_chatflow: ^1.0.0
```
Check for current version number as newer version might be available.
Then run `flutter pub get` to install the package.

## Usage

Here is a basic example to get you started:

```dart
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chatflow/chatflow.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/notifier.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/widgets/image/image_upload_preview_with_text_input.dart';
import 'package:flutter_chatflow/widgets/media_selection_with_text.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatelessWidget {

  List<Message> _messages = [];
  ChatUser author = ChatUser({
    /// It should be unique and persistent for each user
    userID: 'randomID'
  })

  void _addMessage(Message message) {
    /// Handle sending message to server

    ///Sending to local collection below [OPTIONAL if sent to server and listened correctly]
    setState((){
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(String message, {Message? repliedTo}) {
    int createdAt = DateTime.now().millisecondsSinceEpoch;
    
    final textMessage = TextMessage(
      author: author,
      createdAt: createdAt,
      text: message,
      status: DeliveryStatus.sending
    );

    _addMessage(textMessage);
  }

  void _handleOnAttachmentPressed({Message? repliedTo}) async {
    /// logic for adding image to chat.
    /// You could use a dialog to choose between different media types
    /// And rename the function accordingly
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: ChatFlow(
        messages: _messages,
        chatUser: author,
        onSendPressed: _handleSendPressed,
        onAttachmentPressed: _handleOnAttachmentPressed
      ),
    );
  }
}
```

# Sponsors
A huge thank you to our amazing sponsors! Your support is essential in maintaining and improving this project.
<div align="center">
  <h3 style="color:orange">OUR GOLD SPONSORS</h3>
  <a href="https://kostricani.com">
    <img width="30%" alt="Chat Image" src="https://raw.githubusercontent.com/IsaiahTek/flutter_chatflow/main/images/sponsors/gold/kostricani.png" />
  </a>
  <div style="margin-top:30px">
    <a href="mailto://isaiahtech1@gmail.com">Become a Gold Sponsor</a>
  </div>
</div>



## Become Our Sponsor
If you or your organization would like to support this project and be featured here, please consider becoming a sponsor. Your contributions help us to keep the project alive and growing.

Thank you for your generosity!

## Reach Out

For support kindly send a mail to [Engr. Isaiah Pius](mailto://isaiahtech1@gmail.com)

## Contributing

We welcome contributions! Please see our contributing guidelines for more information.

## License

flutter_chatflow is released under the [BSD license.](https://github.com/IsaiahTek/flutter_chatflow/blob/main/LICENSE)