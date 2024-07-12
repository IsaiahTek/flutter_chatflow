import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/widgets/computed_widget.dart';

class RepliedMessageWidget extends StatelessWidget {
  final Message replyMessage;

  const RepliedMessageWidget({required this.replyMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left:
                  BorderSide(width: 6, color: Theme.of(context).primaryColor)),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: Theme.of(context).primaryColor.withOpacity(.04)),
      constraints: BoxConstraints.loose(
          Size.fromWidth(MediaQuery.of(context).size.width)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              constraints: BoxConstraints.loose(const Size(80, 80)),
              child: ComputedMessage(message: replyMessage, isAuthor: true),
            ),
          ),
        ],
      ),
    );
  }
}
