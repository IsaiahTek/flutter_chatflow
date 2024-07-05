import 'dart:async';

/// Notification class for features like watching and streaming
/// user typing activity and other related features.

class FluChatNotifier {
  /// Single instance
  static final FluChatNotifier instance = FluChatNotifier._internal();

  FluChatNotifier._internal() {
    _isTypingStreamController = StreamController<bool>.broadcast();
  }

  /// timestamp for tracking typing state
  late int lastTypedAt;

  late StreamController<bool> _isTypingStreamController;

  /// Typing state stream
  Stream<bool> get isTypingStream => _isTypingStreamController.stream;

  /// Boolean value
  bool isTypingLastState = false;

  /// set typing state
  void setIsTyping() async {
    lastTypedAt = DateTime.now().millisecondsSinceEpoch;
    if (!isTypingLastState) {
      _isTypingStreamController.add(true);
      isTypingLastState = true;
    }
    Future.delayed(const Duration(seconds: 2), () async {
      if (lastTypedAt + 1000 <= DateTime.now().millisecondsSinceEpoch) {
        if (isTypingLastState && !_isTypingStreamController.isPaused) {
          _isTypingStreamController.add(false);
          isTypingLastState = false;
        }
      }
    });
  }
}
