import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';

/// Video Widget Builder Callback
typedef VideoWidgetBuilder = Widget Function(
    {required BuildContext context, required String uri});

/// Custom Widget Builder Callback
typedef CustomWidgetBuilder = Widget Function(
    {required BuildContext context, required String uri});

/// The callback to handle the event when a user sends a text message.
typedef OnSendPressed = void Function(String message, {Message? repliedTo})?;

/// The callback to handle attachment button click.
///
/// Starting from v1.0.0, the callback passes a message to reply to if the user marks a message for replying.
typedef OnAttachmentPressed = Future<void> Function({Message? repliedTo})?;

/// Default action for a particular message gesture defined
typedef DefaultAction = void Function(Message message);

/// A particular message gesture like onLongPressed, onSwipedLeft, onMessageDoubleTapped, etc.
typedef OnMessageGesture = void Function(
    Message message, DefaultAction defaultAction);
