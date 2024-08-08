import 'dart:async';

/// Notification class for features like watching and streaming
/// user typing activity and other related features.
///
/// Sample Code Below:
/// ```dart
/// StreamBuilder(
///   stream: UserTypingStateStream.instance.isTypingStream,
///     builder: (context, data){
///       if(data.hasData && data.data == true){
///         return const Text('Typing');
///       }else{
///         return const SizedBox.shrink();
///       }
///     }
///   )
/// )
/// ```
///
/// So with the above, you can do whatever you want.
///
/// Like sending the event to the server and listening to it at the other users end to notify in chat

class UserTypingStateStream {
  /// Single instance
  static final UserTypingStateStream instance =
      UserTypingStateStream._internal();

  UserTypingStateStream._internal() {
    _isTypingStreamController = StreamController<bool>.broadcast();
  }

  /// timestamp for tracking typing state
  late int _lastTypedAt;

  late StreamController<bool> _isTypingStreamController;

  /// Typing state stream
  Stream<bool> get isTypingStream => _isTypingStreamController.stream;

  /// Boolean value
  bool _isTypingLastState = false;

  // Private method
  void _hanldeSetTyping() {
    _lastTypedAt = DateTime.now().millisecondsSinceEpoch;
    if (!_isTypingLastState) {
      _isTypingStreamController.add(true);
      _isTypingLastState = true;
    }
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (_lastTypedAt + 400 <= DateTime.now().millisecondsSinceEpoch) {
        if (_isTypingLastState && !_isTypingStreamController.isPaused) {
          _isTypingStreamController.add(false);
          _isTypingLastState = false;
        }
      }
    });
  }

  /// set typing state
  void setIsTyping() async {
    _hanldeSetTyping();
  }
}
