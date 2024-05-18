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

A powerful and flexible chat solution for Flutter apps. Features include real-time messaging, private chats, group chats, customizable UI, user management, media sharing, rich text support, typing user(s), etc.

## Features

1. Real-time Messaging: Seamless real-time communication using WebSockets or Firebase.
2. Customizable UI: Easily customizable chat bubbles, themes, and layouts to match your app’s design.
3. User Management: Support for user authentication and profile management.
4. Media Sharing: Send and receive images, videos, and other media files.
5. Group Chats: Create and manage group conversations effortlessly.
6. Rich Text Support: Emoji, links, and formatted text in messages.
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
Then run `flutter pub get` to install the package.

## Usage

Here is a basic example to get you started:

```dart
import 'package:flutter_chatflow/flutter_chatflow.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: ChatFlow(
        currentUser: 'user1',
        onSend: (message) {
          // Handle sending messages
        },
      ),
    );
  }
}
```

## Additional information

### Contributing
We welcome contributions! Please see our contributing guidelines for more information.

### License
flutter_chatflow is released under the MIT License.

