import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatflow/chatflow.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/notifier.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/widgets/image/image_upload_preview_with_text_input.dart';
import 'package:flutter_chatflow/widgets/media_selection_with_text.dart';
import 'package:image_picker/image_picker.dart'; //You can use our defined types or use yours. See documentation on avoiding type conflicts

void main() {
  runApp(const MainApp());
}

final RouteObserver routeObserver = RouteObserver<ModalRoute>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      theme: ThemeData(
        colorScheme: const ColorScheme.highContrastLight(
            primary: Colors.amber, secondary: Color.fromARGB(255, 110, 38, 12)),
      ),
      color: Colors.white,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with RouteAware {
  bool _hideKeyboard = false;
  List<Message> messages = [
    ChatInfo(
        createdAt: DateTime.now().millisecondsSinceEpoch,
        info: "Messages and calls are end-to-end encrypted.")
  ];
  ChatUser john = const ChatUser(userID: "john");
  ChatUser jane = const ChatUser(userID: "jane");
  ChatUser faith = const ChatUser(userID: "Matthew");
  ChatUser jerry = const ChatUser(userID: "Saturday");
  ChatUser mark = const ChatUser(userID: "Zackaxorphy");

  List<ChatUser> get users => [john, jane];

  bool isJohn = true;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.initState();
  }

  @override
  didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.didPopNext();
  }

  @override
  dispose() {
    routeObserver.unsubscribe(this);
    return super.dispose();
  }

  void onSendPressed(String message, {Message? repliedTo}) {
    TextMessage textMessage = TextMessage(
        author: users[(Random().nextDouble() * users.length)
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

  void setInProgressToDone() {
    // setState(() {
    inProgress = false;
    // });
  }

  Future<void> _handleImageSelection({Message? repliedTo}) async {
    setState(() {
      inProgress = true;
    });
    try {
      final results = await _picker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 1440,
      );

      handleSetSelectionWithText(
          List<MediaSelectionWithText> selectionWithText) async {
        if (selectionWithText.isNotEmpty) {
          // final bytes = await result.readAsBytes();
          // final image = await decodeImageFromList(bytes);

          for (var element in selectionWithText) {
            int createdAt = DateTime.now().millisecondsSinceEpoch;
            final message = ImageMessage(
                author: users[(Random().nextDouble() * users.length).toInt()],
                createdAt: createdAt,
                repliedTo: repliedTo,
                uri: element.uri,
                status: DeliveryStatus.sending,
                text: element.text);

            messages.insert(0, message);
          }
        }
      }

      //
      if (mounted && results.isNotEmpty) {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageUploadPreviewWithTextInput(
                      imagesUri: results.map((e) => e.path).toList(),
                      setMediaSelectionsWithText: handleSetSelectionWithText,
                    )));
        setState(() {
          isMenuVisible = false;
          selectedMessages = [];
          inProgress = false;
        });
      } else {
        setState(() {
          isMenuVisible = false;
          selectedMessages = [];
          inProgress = false;
        });
      }
    } catch (e) {
      // Handle error
      setState(() {
        inProgress = false;
      });
    }
  }

  bool inProgress = false;

  List<Message>? selectedMessages;

  bool isMenuVisible = false;

  bool get _canPop {
    if (isMenuVisible) {
      return false;
    } else {
      return true;
    }
  }

  _handleMessageSelectionChange(List<Message> messages) {
    setState(() {
      selectedMessages = messages;
      if (messages.isNotEmpty) {
        isMenuVisible = true;
      } else {
        isMenuVisible = false;
      }
    });
  }

  toggleMenuVisibility() {
    setState(() {
      isMenuVisible = !isMenuVisible;
    });
  }

  // GlobalKey<_ChatFlowState> chatFlowKey =

  handleOnExitMenu() {
    ChatFlowEvent.unselectAllMessages();
    selectedMessages = [];
    setState(() {
      isMenuVisible = false;
    });
  }

  void _showMenu(
      BuildContext context, Message message, Function(Message message) action) {
    FocusManager.instance.primaryFocus?.unfocus();
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Select an option'),
        message: const Text('Choose wisely'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              action(message);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete for Me',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              action(message);
              Navigator.pop(context);
            },
            child: const Text('Delete for Everyone'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              action(message);
            },
            child: const Text('Reply'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              // Add your action here
              if (kDebugMode) {
                print('Option 2 selected');
              }
            },
            child: const Text('Forward'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    ).then((_) {
      // FocusScope.of(context).unfocus();
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: _canPop,
        onPopInvoked: (_) {
          handleOnExitMenu();
        },
        child: !inProgress
            ? Scaffold(
                backgroundColor: const Color.fromARGB(255, 230, 230, 230),
                appBar: isMenuVisible
                    ? AppBar(
                        title: SelectedMessageMenu(
                          messages: selectedMessages!,
                          onExitMenu: handleOnExitMenu,
                        ),
                      )
                    : AppBar(
                        leadingWidth: 100,
                        actions: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _hideKeyboard = !_hideKeyboard;
                                });
                              },
                              icon: Icon(Icons.change_circle_rounded)),
                          IconButton(
                              onPressed: null, icon: Icon(Icons.more_vert))
                        ],
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "ChatFlow",
                              style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.fontSize),
                            ),
                            StreamBuilder(
                                stream: UserTypingStateStream
                                    .instance.isTypingStream,
                                builder: (context, data) {
                                  if (data.hasData && data.data == true) {
                                    return const Text(
                                      'Typing',
                                      style: TextStyle(fontSize: 14),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                }),
                          ],
                        )),
                body: Column(
                  children: [
                    Expanded(
                      child: ChatFlow(
                        messages: messages,
                        chatUser: john,
                        onSendPressed: onSendPressed,
                        onAttachmentPressed: _handleImageSelection,
                        onMessageLongPressed: (Message message,
                                Function(Message message) defaultAction) =>
                            _showMenu(context, message, defaultAction),
                        onImageMessageTapped: (Message message,
                            Function(Message message) defaultAction) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                actions: [
                                  CupertinoActionSheetAction(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Don't")),
                                  CupertinoActionSheetAction(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Don't")),
                                  CupertinoActionSheetAction(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Don't")),
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        defaultAction(message);
                                      },
                                      child: Text("Open Image"))
                                ],
                              );
                            },
                          ).then((c) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          });
                        },
                        // onReplyToMessage: (message, action){
                        // },
                        showUserAvatarInChat: true,
                        minImagesToGroup: 5,
                        onMessageSelectionChanged:
                            _handleMessageSelectionChange,
                        hideDefaultInputWidget: _hideKeyboard,
                      ),
                    ),
                    if (_hideKeyboard)
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromARGB(255, 255, 255, 255)),
                        child: Row(
                          children: [
                            CupertinoButton(
                                child: Transform.rotate(
                                    angle: pi / 6,
                                    child: Icon(
                                      Icons.attach_file,
                                      size: 24,
                                    )),
                                onPressed: _handleImageSelection),
                            Expanded(
                                child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          // width: 1,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: "Start typing",
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 9)),
                                            onSubmitted: onSendPressed,
                                          ),
                                        ),
                                        Container(
                                            // color: Colors.blue,
                                            alignment: Alignment.topCenter,
                                            padding:
                                                EdgeInsets.only(bottom: 90),
                                            child: IconButton(
                                                icon: Icon(Icons.gif),
                                                onPressed: () {}))
                                      ],
                                    ))),
                            CupertinoButton(
                                child: Icon(Icons.mic), onPressed: null)
                          ],
                        ),
                      )
                  ],
                ),
              )
            : Scaffold(
                backgroundColor:
                    Theme.of(context).colorScheme.secondary.withAlpha(100),
                body: const Center(
                    child: CircularProgressIndicator(
                  color: Colors.amber,
                )),
              ));
  }
}

class SelectedMessageMenu extends StatelessWidget {
  final List<Message> messages;
  final Function() onExitMenu;
  const SelectedMessageMenu(
      {super.key, required this.messages, required this.onExitMenu});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  onExitMenu();
                },
                icon: Icon(Platform.isIOS
                    ? Icons.arrow_back_ios_new_rounded
                    : Icons.arrow_back_rounded)),
            const SizedBox(
              width: 20,
            ),
            Text('${messages.length}')
          ],
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.reply)),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.mark_chat_read_outlined)),
            IconButton(
                onPressed: () {},
                icon: Transform.flip(
                    flipX: true, child: const Icon(Icons.reply_all))),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.mark_chat_read_outlined))
          ],
        )
      ],
    );
  }
}
