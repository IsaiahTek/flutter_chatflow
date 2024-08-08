import 'package:flutter/material.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/utils/utils.dart';

/// Internal use only
class SentAt extends StatelessWidget {
  /// Internal use only
  final int timestamp;

  /// Internal use only
  final MessageType type;

  /// Internal use only
  const SentAt({super.key, required this.type, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return type != MessageType.text
        ? Text(
            getSentAt(timestamp),
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
                shadows: const [
                  Shadow(
                    offset: Offset(1, 1),
                    color: Colors.black,
                    // blurRadius: 2
                  )
                ],
                color: Colors.white),
          )
        : Text(
            getSentAt(timestamp),
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.labelSmall?.fontSize,
                shadows: const [
                  Shadow(
                    offset: Offset(1, 1),
                    color: Colors.white,
                    // blurRadius: 2
                  )
                ]),
          );
  }
}
