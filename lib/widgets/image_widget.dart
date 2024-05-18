import 'dart:io';

import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget{

  final String uri;
  const ImageWidget({
    super.key,
    required this.uri
  });

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(uri),
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Theme.of(context).primaryColor, Colors.white10]
            )
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: const Text(
            "No image found with the file name", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
          ),
        );
      },
    );
  }
  
}