class MediaSelectionWithText{
  final String uri;
  String? text;
  MediaSelectionWithText({
    required this.uri,
    this.text
  });

  copyWith({required String text}){
    this.text = text;
  }
}