import 'dart:async';

class FluChatNotifier{

  static final FluChatNotifier instance = FluChatNotifier._internal();

  FluChatNotifier._internal(){
    _isTypingStreamController = StreamController<bool>.broadcast();
  }

  late int lastTypedAt;

  late StreamController<bool> _isTypingStreamController;

  Stream<bool> get isTypingStream =>_isTypingStreamController.stream;
  
  bool isTypingLastState = false;

  // void initialize(){
  //   _isTypingStreamController = StreamController<bool>();
  // }

  void setIsTyping()async{
    lastTypedAt = DateTime.now().millisecondsSinceEpoch;
    if(!isTypingLastState){
      _isTypingStreamController.add(true);
      isTypingLastState = true;
    }
    Future.delayed(const Duration(seconds: 2), ()async{
      if(lastTypedAt + 1000 <= DateTime.now().millisecondsSinceEpoch){
        if(isTypingLastState && !_isTypingStreamController.isPaused){
          _isTypingStreamController.add(false);
          isTypingLastState = false;
        }
      }
    });
  }

}