import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/utils/types.dart';

/// Message Gesture Callback Manager for global access of predefined callbacks across widgets in the tree
class MessageGestureCallbackManager {
  // Private constructor
  MessageGestureCallbackManager._internal();

  // The single instance of the class
  static final MessageGestureCallbackManager _instance =
      MessageGestureCallbackManager._internal();

  /// Factory constructor to return the same instance
  static MessageGestureCallbackManager get instance => _instance;

  // Collection of callbacks
  final Map<CallbackName, OnMessageGesture> _callbacks = {};

  /// Method to register a callback
  void registerCallback(CallbackName name, OnMessageGesture? callback) {
    if (callback != null) {
      _callbacks[name] = callback;
    }
  }

  /// Method to get a callback
  OnMessageGesture? getCallback(CallbackName name) {
    return _callbacks[name];
  }

  /// Method to execute a callback
  void executeCallback(CallbackName name, Message message,
      Function(Message message) defaultAction) {
    if (_callbacks.containsKey(name)) {
      _callbacks[name]!(message, defaultAction);
    }
  }

  /// Method to remove a callback
  void removeCallback(CallbackName name) {
    _callbacks.remove(name);
  }
}
