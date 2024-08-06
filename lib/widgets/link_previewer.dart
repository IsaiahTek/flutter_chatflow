part of "../library.dart";

/// This class is only to be modified by package maintainers/contributors.
class LinkPreviewer extends StatefulWidget {
  
  /// The uri/url text
  final String url;

  /// Constructor
  const LinkPreviewer({
    super.key,
    required this.url
  });

  @override
  State<LinkPreviewer> createState() => _LinkPreviewerState();
}

class _LinkPreviewerState extends State<LinkPreviewer> {
  String? _title;
  String? _description;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchLinkPreview(widget.url);
  }

  Future<void> _fetchLinkPreview(String url) async {
    try {
      final uri = Uri.parse(url);
      final request = await HttpClient().getUrl(uri);
      final response = await request.close();
      if (response.statusCode == 200) {
        final contents = StringBuffer();
        await for (var data in response.transform(utf8.decoder)) {
          contents.write(data);
        }
        final document = contents.toString();
        _parseHtml(document);
      }
    } catch (e) {
      print('Error fetching link preview: $e');
    }
  }

  void _parseHtml(String document) {
    final titleStart = document.indexOf('<title>');
    final titleEnd = document.indexOf('</title>');
    if (titleStart != -1 && titleEnd != -1) {
      _title = document.substring(titleStart + 7, titleEnd);
    }

    final metaTags = RegExp(r'<meta[^>]+>');
    final matches = metaTags.allMatches(document);

    for (final match in matches) {
      final tag = match.group(0);
      if (tag != null) {
        if (tag.contains('property="og:description"') || tag.contains('name="description"')) {
          final content = RegExp(r'content="([^"]+)"').firstMatch(tag)?.group(1);
          if (content != null) {
            _description = content;
          }
        }
        if (tag.contains('property="og:image"')) {
          final content = RegExp(r'content="([^"]+)"').firstMatch(tag)?.group(1);
          if (content != null) {
            _imageUrl = content;
          }
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(widget.url)) {
          await launch(widget.url);
        }
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_imageUrl != null) Image.network(_imageUrl!),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_title != null) Text(_title!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (_description != null) Text(_description!, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> canLaunch(String url) async {
    try {
      final uri = Uri.parse(url);
      return await HttpClient().getUrl(uri).then((_) => true).catchError((_) => false);
    } catch (e) {
      return false;
    }
  }

  Future<void> launch(String url) async {
    if (await canLaunch(url)) {
      print('Launching $url');
      // Here you would launch the URL in a webview or browser.
      // Since we can't launch URLs directly in this example, we just print the URL.
    } else {
      print('Could not launch $url');
    }
  }
}
