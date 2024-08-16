/// Visibility Interface
mixin TextVisibility{
  /// Text
  String? text;
  /// A flag to either hide or show text
  bool? shouldHideText;

  /// Initialise the interface
  // TextVisibility({
  //   required this.text,
  //   this.shouldHideText
  // });

  /// Check and return if it is a text and not empty
  bool hasText() {
    if (text is String) {
      return text!.isNotEmpty && !(shouldHideText ?? false);
    } else {
      return false;
    }
  }

}