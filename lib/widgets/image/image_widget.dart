part of '../../library.dart';

/// Image widget to display image messages
class ImageWidget extends StatelessWidget {
  /// Image url/uri or local file path
  ///
  /// ChatFlow can display server images and local file.
  final String uri;

  /// Ensure you pass in the uri [The uri could be a path as well]
  const ImageWidget({super.key, required this.uri});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: File(uri).exists(),
        builder: ((context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!) {
              return Image.file(
                File(uri),
                errorBuilder: (context, error, stackTrace) => Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Theme.of(context).primaryColor.withOpacity(.8),
                    Theme.of(context).primaryColor.withAlpha(255)
                  ])),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Text(
                    "$error",
                    // "Local file image not found with the file name \n${Uri.file(uri).pathSegments[Uri.file(uri).pathSegments.length - 1]}\nEnsure it hasn't been deleted from the device",
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ),
                ),
              );
            } else {
              return Image.network(
                uri,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Theme.of(context).primaryColor.withOpacity(.8),
                    Theme.of(context).primaryColor.withAlpha(255)
                  ])),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  child: Text(
                    "Server image not found with the file name \n${Uri.file(uri).pathSegments[Uri.file(uri).pathSegments.length - 1]}\nEnsure it hasn't been deleted on the server",
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ),
                ),
              );
            }
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Theme.of(context).primaryColor.withOpacity(.8),
                Theme.of(context).primaryColor.withAlpha(255)
              ])),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Text(
                "Fetching image \n${Uri.file(uri).pathSegments[Uri.file(uri).pathSegments.length - 1]}\nEnsure your internet connection is healthy",
                style: const TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.white),
              ),
            );
          }
        }));
  }
}
