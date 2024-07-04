import 'dart:io';

import 'package:flutter/material.dart';

class AudioWidget extends StatelessWidget{

  final String uri;
  const AudioWidget({
    super.key,
    required this.uri
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
    // Image.file(
    //   File(uri),
    //   errorBuilder: (context, error, stackTrace) {
    //     return Container(
    //       decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //           colors: [Theme.of(context).primaryColor.withOpacity(.3), Colors.white10.withOpacity(.5)]
    //         )
    //       ),
    //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
    //       child: Text(
    //         "No image found with the file name \n${Uri.file(uri).pathSegments[Uri.file(uri).pathSegments.length-1]}", style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black54),
    //       ),
    //     );
    //   },
    // );
  }
  
}