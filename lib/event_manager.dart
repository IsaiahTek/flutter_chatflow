/// Needed for triggering event from within your controlled UI then ChatFlow listens to your events.
class EventManager {
  // Singleton pattern for a single instance of EventManager
  EventManager._privateConstructor();
  static final EventManager _instance = EventManager._privateConstructor();

  /// Single and coherent instance of `EventManger`
  static EventManager get instance => _instance;

  final List<Function()> _listeners = [];

  /// For internal use only
  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  /// For internal use only
  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  /// For internal use only
  void unselectAllMessages() {
    for (var listener in _listeners) {
      listener();
    }
  }

  // void setMessageToReply(){
    
  // }
}
