/// A class for Media Upload with optional text
class MediaSelectionWithText {
  /// uri/url or local file path of selected file
  final String uri;

  /// [Optional] text
  String? text;

  /// Create the instance
  MediaSelectionWithText({required this.uri, this.text});

  /// Make a copy of this with the new text
  copyWith({required String text}) {
    this.text = text;
  }
}
