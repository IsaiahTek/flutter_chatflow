import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chatflow/library.dart';
import 'package:flutter_chatflow/event_manager.dart';
import 'package:flutter_chatflow/message_gesture_callback_manager.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/platform_implementation/platform_web.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/utils/utils.dart';
import 'package:flutter_chatflow/widgets/chat_bubble.dart';
import 'package:flutter_chatflow/widgets/image/grouped_images.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'platform_implementation/platform_io.dart' if (dart.library.html) 'platform_implementation/platform_web.dart';

/// Entry point to using the ChatFlow.
class ChatFlow extends StatefulWidget {
  /// The messages to be shown in the chat
  final List<Message> messages;

  /// The current user of the chat. Ensure the `[userID]` is unique.
  final ChatUser chatUser;

  /// The callback to handle the event when a user sends a text message.
  final OnSendPressed onSendPressed;

  /// The callback for handling attachment button click.
  final OnAttachmentPressed onAttachmentPressed;

  /// The callback when the user presses down a message for long.
  ///
  /// By default, the message is selected.
  ///
  /// Example of how to intercept the default gesture event on message.
  ///
  /// Calling the second argument `defaultAction` implements the default action together with your custom action.
  /// Sample code below
  /// ```dart
  /// ChatFlow(
  ///   messages: messages,
  ///   chatUser: chatUsers,
  ///   onSendPressed: onSendPressed,
  ///   onAttachmentPressed: _handleImageSelection,
  ///   onMessageLongPressed: (Message message, Function(Message message) defaultAction) {
  ///     defaultAction(message);
  ///   },
  ///   onMessageSelectionChanged: _handleMessageSelectionChange,
  /// ),
  /// ```
  /// In the example we executed a custom code before calling the default action which is to select the message.
  ///
  /// Feel free to use it as you want!

  /// Callback for message long pressed
  final OnMessageGesture? onMessageLongPressed;

  /// Callback for image message tapped
  final OnMessageGesture? onImageMessageTapped;

  /// The callback when the user presses down a message for long. By default, the message is selected.
  final OnMessageGesture? onMessageDoubleTapped;

  /// The callback to handle when a message is gestured to be replied to. By default, when a user swipes his/her message left or when a user swipes other person's message right we chain a replyTo event to such a gesture. To override such swipe behaviour or to even intercept it and add custom action together with the default pass in the `onReplyToMessage` callback and you will have access to the gestured message.
  final OnMessageGesture? onReplyToMessage;

  /// Callback for when a message is swiped left
  final void Function(Message swipedMessage)? onMessageSwipedLeft;

  /// Callback for when a message is swiped right
  final void Function(Message swipedMessage)? onMessageSwipedRight;

  /// Set this as true if you want peer user avatar/profile photo to be shown in chat. This is typically used in group chat
  final bool? showUserAvatarInChat;

  /// Callback to handle the user delete button click after selecting a message
  final void Function(List<Message> messages)? onMessageSelectionChanged;

  /// [Optional] Defaults to true. If you don't want to group consecutive images just make it false
  final bool? shouldGroupConsecutiveImages;

  /// [Optional] By the default, if consecutive images are upto 4 or more by the same author and on the same day, these images would be grouped.
  ///
  /// Change this value if you want it to be other amount greater than 4. It can't be less that 4
  final int? minImagesToGroup;

  /// Theme for customaziation
  final Theme? theme;

  /// Widget for custom message
  final CustomWidgetBuilder? customWidgetBuilder;

  /// Widget for video message. ChatFlow does not create this widget as we focus on chat management and try to avoid conflicts with your preference
  final CustomWidgetBuilder? videoWidgetBuilder;

  /// Widget for displaying pdf files
  final CustomWidgetBuilder? pdfWidgetBuilder;

  /// Widget for displaying audio files
  final CustomWidgetBuilder? audioWidgetBuilder;

  /// Widget for displaying doc files
  final CustomWidgetBuilder? docWidgetBuilder;

  /// Option for hiding ChatFlow default input widget.
  ///
  /// ChatFlow default input widget contains basically 3 other widgets:
  ///   1. TextField
  ///   2. Send Button
  ///   3. Attachment Button
  ///
  /// Developers might want to use custom input widget for better controls. Just pass in the
  /// `hideDefaultInputWidget:true`
  ///
  /// Default: `final hideDefaultInputWidget = false`;
  final bool? hideDefaultInputWidget;

  List<Map<CallbackName, OnMessageGesture?>> get _registrableCallbackNames => [
        {CallbackName.onMessageLongPressed: onMessageLongPressed},
        {CallbackName.onImageMessageTapped: onImageMessageTapped},
        {CallbackName.onMessageDoubleTapped: onMessageDoubleTapped},
        {CallbackName.onReplyToMessage: onReplyToMessage},
      ];

  /// ChatFlow used to add chat features to the app
  ChatFlow(
      {super.key,
      required this.messages,
      required this.chatUser,
      this.onSendPressed,
      this.onAttachmentPressed,
      this.onMessageLongPressed,
      this.onMessageDoubleTapped,
      this.onImageMessageTapped,
      this.onMessageSwipedLeft,
      this.onMessageSwipedRight,
      this.onReplyToMessage,
      this.showUserAvatarInChat,
      this.onMessageSelectionChanged,
      this.theme,
      this.videoWidgetBuilder,
      this.pdfWidgetBuilder,
      this.customWidgetBuilder,
      this.audioWidgetBuilder,
      this.docWidgetBuilder,
      this.shouldGroupConsecutiveImages,
      this.minImagesToGroup,
      this.hideDefaultInputWidget = false}) {
    for (var i = 0; i < _registrableCallbackNames.length; i++) {
      CallbackName name = _registrableCallbackNames[i].keys.first;
      OnMessageGesture? callback = _registrableCallbackNames[i].values.first;
      MessageGestureCallbackManager.instance.registerCallback(name, callback);
    }
  }

  @override
  State<StatefulWidget> createState() => _ChatFlowState();
}

class _ChatFlowState extends State<ChatFlow> {
  final AutoScrollController _scrollController = AutoScrollController();

  Message? replyMessage;

  List<Message> get _messages =>
      widget.messages..sort((a, b) => a.createdAt.compareTo(b.createdAt));

  bool showUserAvatarInChat = false;

  List<ImageMessage> get _imageMessages => _messages
      .where((element) => element.type == MessageType.image)
      .cast<ImageMessage>()
      .toList();

  List<Message> selectedMessages = [];

  clearSelectedMessages() {
    setState(() {
      selectedMessages = [];
    });
  }

  _handleSetSelectedMessage(List<Message> list) {
    if (widget.onMessageSelectionChanged != null) {
      setState(() {
        selectedMessages = list;
      });
      widget.onMessageSelectionChanged!(list);
    }
  }

  _handleUnselectAllMessages() {
    selectedMessages = [];
  }

  @override
  void didChangeDependencies() {
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   _scrollToBottomWhenReady();
    // });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    setState(() {
      showUserAvatarInChat = widget.showUserAvatarInChat ?? false;
    });
    EventManager.instance.addListener(_handleUnselectAllMessages);
    super.initState();
  }

  @override
  void dispose() {
    EventManager.instance.removeListener(_handleUnselectAllMessages);
    _scrollController.dispose();
    super.dispose();
  }

  String currentScrolledToItemKeyHashCode = "";
  bool shouldShowHighlightForScroll(String keyHashCode) {
    if (keyHashCode == currentScrolledToItemKeyHashCode) {
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          currentScrolledToItemKeyHashCode = "";
        });
      });
      return true;
    } else {
      return false;
    }
  }

  void handleSetReplyMessage(Message reply) {
    OnMessageGesture? onReplyToMessage = MessageGestureCallbackManager.instance
        .getCallback(CallbackName.onReplyToMessage);
    if (onReplyToMessage != null) {
      onReplyToMessage(reply, (reply) {
        setState(() {
          replyMessage = reply;
        });
      });
    } else {
      setState(() {
        replyMessage = reply;
      });
    }
  }

  void handleUnsetReplyMessage() {
    setState(() {
      replyMessage = null;
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
    // _getSizes();
  }

  void handleOnSendPressed(String text, {Message? repliedTo}) {
    if (widget.onSendPressed != null) {
      widget.onSendPressed!(text, repliedTo: repliedTo);
      _scrollToBottom();
    }
  }

  Future<void> handleOnAttachmentPressed({Message? repliedTo}) async {
    if (widget.onAttachmentPressed != null) {
      await widget.onAttachmentPressed!(repliedTo: repliedTo);
    }
  }

  void _scrollToBottomWhenReady() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && _messages.isNotEmpty) {
        _scrollToBottom();
      } else {
        Future.delayed(
            const Duration(milliseconds: 100), _scrollToBottomWhenReady);
      }
    });
  }

  final _ItemHeightCache _heightCache = _ItemHeightCache();

  void _scrollToIndex(int index) {
    // double offset = _itemHeights[index];
    _scrollController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.middle);
    _scrollController.highlight(index);
  }

  void _scrollToMessage(Message message) {
    // double offset =
    //     _heightCache.getCummulative(message.key.hashCode.toString());
    int index = _messages.indexWhere((a) => a.createdAt == message.createdAt);
    debugPrint(
        "AUTOSCROLLED $index ${DateTime.fromMillisecondsSinceEpoch(message.createdAt)} $message");
    _scrollToIndex(index);
  }

  void handleScrollToRepliedMessage(Message repliedMessage) {
    //
    int repliedMessageIndex = _messages
        .indexWhere((test) => test.createdAt == repliedMessage.createdAt);
    if (repliedMessageIndex != -1) {
      setState(() {
        currentScrolledToItemKeyHashCode =
            repliedMessage.key.hashCode.toString();
      });
    }
    _scrollToMessage(repliedMessage);
  }

  void _getSizes() {
    for (int i = 0; i < _messages.length; i++) {
      Message message = _messages[i];

      if (!_heightCache.hasItem(message.key.hashCode.toString())) {
        final double? height =
            (message.key?.currentContext?.findRenderObject() as RenderBox?)
                ?.size
                .height;

        if (height != null) {
          _heightCache.setHeight(message.key.hashCode.toString(), height);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ConsecutiveOccurrence> groupedImages =
        (widget.shouldGroupConsecutiveImages ?? true)
            ? getConsecutives(
                items: _messages,
                check: ImageMessage(
                    author: const ChatUser(userID: "userID"),
                    createdAt: 0,
                    uri: "uri"),
                amount: (widget.minImagesToGroup != null &&
                        widget.minImagesToGroup! > 3)
                    ? widget.minImagesToGroup
                    : 4)
            : [];
    return Column(
      children: [
        Expanded(
            child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: ListView.builder(
                    // reverse: true,
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: const Duration(seconds: 2),
                        color: shouldShowHighlightForScroll(
                                _messages[index].key.hashCode.toString())
                            ? Theme.of(context).primaryColor.withValues(alpha: .2)
                            : null,
                        curve: Curves.fastOutSlowIn,
                        child: AutoScrollTag(
                          key: ValueKey(_messages[index].createdAt),
                          controller: _scrollController,
                          index: index,
                          highlightColor:
                              Theme.of(context).primaryColor.withValues(alpha: .2),
                          child: SizedBox(
                            key: _messages[index].key,
                            width: MediaQuery.of(context).size.width,
                            child: (indexIsInConsecutivesAndIsFirstTake(
                                    groupedImages, index))
                                ? Column(
                                    children: [
                                      _TimePartitionText(
                                          createdAt: _messages[index].createdAt,
                                          previousMessageCreatedAt:
                                              _messages[index - 1].createdAt),
                                      if (_messages[index].type ==
                                          MessageType.info)
                                        _InfoMessage(message: _messages[index]),
                                      GroupedImages(
                                        images: getGroupedImageMessages(
                                            _messages, groupedImages, index),
                                        chatUser: widget.chatUser,
                                        isGroupChat:
                                            widget.showUserAvatarInChat ??
                                                false,
                                      ),
                                    ],
                                  )
                                : (indexIsInConsecutives(groupedImages, index))
                                    ? const SizedBox.shrink()
                                    : ChatBubble(
                                        message: _messages[index],
                                        chatUser: widget.chatUser,
                                        imageMessages: _imageMessages,
                                        showUserAvatarInChat:
                                            showUserAvatarInChat,
                                        previousMessageCreatedAt: index > 0
                                            ? _messages[index - 1].createdAt
                                            : null,
                                        currentMessageIndex: index,
                                        setReplyMessage: handleSetReplyMessage,
                                        setSelectedMessages:
                                            _handleSetSelectedMessage,
                                        selectedMessages: selectedMessages,
                                        videoWidgetBuilder:
                                            widget.videoWidgetBuilder,
                                        pdfWidgetBuilder:
                                            widget.pdfWidgetBuilder,
                                        customWidgetBuilder:
                                            widget.customWidgetBuilder,
                                        onTappedRepliedMessagePreview:
                                            handleScrollToRepliedMessage,
                                      ),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        )),
        if (!(widget.hideDefaultInputWidget ?? false))
          Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            margin: EdgeInsets.only(bottom: PlatformHelper.isIOS ? 30 : 0),
            child: ChatInputWidget(
              onSendPressed: handleOnSendPressed,
              onAttachmentPressed: handleOnAttachmentPressed,
              replyMessage: replyMessage,
              pdfWidgetBuilder: widget.pdfWidgetBuilder,
              customWidgetBuilder: widget.customWidgetBuilder,
              videoWidgetBuilder: widget.videoWidgetBuilder,
              isAuthor: widget.chatUser.userID == replyMessage?.author.userID,
              unsetReplyMessage: handleUnsetReplyMessage,
            ),
          )
      ],
    );
  }
}

/// Use this class' static members to trigger functions in your code that you want ChatFlow to handle
class ChatFlowEvent {
  /// Used when closing/exiting selected messages based on your custom user event like tapping a button icon for disposing all selected messages
  static void unselectAllMessages() {
    _unselectAllMessages();
  }

  static void _unselectAllMessages() {
    EventManager.instance.unselectAllMessages();
  }
}

class _TimePartitionText extends StatelessWidget {
  final int? previousMessageCreatedAt;
  final int createdAt;

  const _TimePartitionText(
      {required this.createdAt, this.previousMessageCreatedAt});

  @override
  Widget build(BuildContext context) {
    return (!isSameDay(previousMessageCreatedAt, createdAt))
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0.00, 0.5),
                          color: Colors.black26,
                        )
                      ]),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    computeTimePartitionText(createdAt),
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize:
                            Theme.of(context).textTheme.labelSmall?.fontSize),
                  ),
                ),
              )
            ],
          )
        : const SizedBox.shrink();
  }
}

class _InfoMessage extends StatelessWidget {
  final Message message;
  const _InfoMessage({required this.message});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          constraints: BoxConstraints.loose(MediaQuery.of(context).size),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.yellow[50],
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0.00, 0.5),
                    color: Colors.black26,
                  )
                ]),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(
              (message as ChatInfo).info,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: Theme.of(context).textTheme.labelSmall?.fontSize),
            ),
          ),
        )
      ],
    );
  }
}

class _ItemHeightCache {
  final List<Map<String, double>> _cache = [];

  double getHeight(int index) {
    return _cache[index].values.isNotEmpty ? _cache[index].values.first : 0;
  }

  int getCacheIndexOf(String id) {
    return _cache.indexWhere((en) => en.keys.contains("widget-$id"));
  }

  double getCummulative(String id) {
    double cummulative = 0;
    for (var i = 0; i < getCacheIndexOf(id); i++) {
      cummulative = cummulative + getHeight(i);
    }

    return cummulative;
  }

  void setHeight(String id, double height) {
    if (!hasItem(id)) {
      _cache.add({"widget-$id": height});
      debugPrint("CACHED HEIGHTS $_cache");
    }
  }

  bool hasItem(String id) {
    return getCacheIndexOf(id) > -1;
  }
}
