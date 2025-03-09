import 'package:flutter/material.dart';
import 'package:flutter_chatflow/platform_implementation/file_io.dart';

/// Image Wrapper for Image.file
class LocalImageWidget extends StatelessWidget{
  
  /// File path
  final String uri;

  /// Image Wrapper for Image.file
  const LocalImageWidget({super.key, required this.uri});

  @override
  Widget build(BuildContext context) {
    return Image.file(
                FileManager.readFile(uri),
                errorBuilder: (context, error, stackTrace) => Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Theme.of(context).primaryColor.withValues(alpha: .8),
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
  }
}