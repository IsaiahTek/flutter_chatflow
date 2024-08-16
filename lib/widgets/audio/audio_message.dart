part of '../../library.dart';

/// Audio message widget
class AudioMessageWidget extends StatelessWidget {
  /// uri/url or local file path
  final String uri;

  /// Create the widget and pass in for ChatFlow to use
  final VideoWidgetBuilder audioWidgetBuilder;  

  /// [Optional] text
  final String? text;

  /// If set to true, widget is displayed to the right
  final bool? isAuthor;

  /// Flag to either hide associated text. Shown by default
  final bool? shouldHideText;

  /// Audio message widget to display an audio message type
  const AudioMessageWidget({
    super.key,
    required this.uri,
    required this.audioWidgetBuilder,
    this.text,
    this.isAuthor,
    this.shouldHideText
  });

  /// Check and return if it is a text and not empty
  bool hasText() {
    if (text is String) {
      return text!.isNotEmpty && !(shouldHideText ?? false);
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: audioWidgetBuilder(context: context, uri: uri),
        ),
        if(hasText()) Text(text!)
      ],
    ));
  }
}
