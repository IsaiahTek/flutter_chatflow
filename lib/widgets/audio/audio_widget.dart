part of '../../library.dart';

/// Audio Widget
class AudioWidget extends StatelessWidget {
  /// uri/url or path of the audio file
  final String uri;

  /// [Optional] text to be displayed with the video
  final VideoWidgetBuilder audioWidgetBuilder;

  /// Pass in the uri
  const AudioWidget({super.key, required this.uri, required this.audioWidgetBuilder});

  @override
  Widget build(BuildContext context) {
    return audioWidgetBuilder(context: context, uri: uri);
  }
}
