import 'package:flutter/material.dart';
import 'package:flutter_chatflow/models.dart';
import 'package:flutter_chatflow/utils/type_defs.dart';
import 'package:flutter_chatflow/utils/types.dart';
import 'package:flutter_chatflow/utils/utils.dart';
import '../library.dart';

/// To be used internally by the package developers and contributors
///
/// Do not directly use this. The package uses it behind the scene.
class RepliedMessageWidget extends StatelessWidget {
  /// The message to be replied to.
  final Message replyMessage;

  /// Internal use only
  final bool isAuthor;

  /// Optional widget to be passed
  final CustomWidgetBuilder? customWidgetBuilder;

  /// Optional widget to be passed
  final CustomWidgetBuilder? videoWidgetBuilder;

  /// Optional widget to be passed
  final CustomWidgetBuilder? pdfWidgetBuilder;

  /// Constructor to build everything here.
  const RepliedMessageWidget(
      {required this.replyMessage,
      required this.isAuthor,
      super.key,
      this.customWidgetBuilder,
      this.pdfWidgetBuilder,
      this.videoWidgetBuilder});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              left:
                  BorderSide(width: 6, color: Theme.of(context).primaryColor)),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          color: Theme.of(context).primaryColor.withValues(alpha: .04)),
      constraints: BoxConstraints.loose(
          Size.fromWidth(MediaQuery.of(context).size.width)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: MediaQuery.of(context).size.width,
        child: (replyMessage.type != MessageType.text)
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      constraints:
                          const BoxConstraints(maxHeight: 60, maxWidth: 80),
                      margin: const EdgeInsets.only(right: 10),
                      child: ComputedMessage(
                        message: replyMessage,
                        isAuthor: true,
                        shouldHideText: true,
                        shouldFitToAvailableSize: true,
                        customWidgetBuilder: customWidgetBuilder,
                        pdfWidgetBuilder: pdfWidgetBuilder,
                        videoWidgetBuilder: videoWidgetBuilder,
                      )),
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text(
                          isAuthor
                              ? "You"
                              : replyMessage.author.name ??
                                  replyMessage.author.userID,
                          style: TextStyle(
                              color: createColorFromHashCode(
                                      replyMessage.author.userID.hashCode)
                                  .main,
                              fontWeight: FontWeight.bold),
                        ),
                        RichText(
                          text: TextSpan(children: <InlineSpan>[
                            WidgetSpan(
                                child: Icon(
                              replyMessage.type == MessageType.image
                                  ? Icons.image_outlined
                                  : replyMessage.type == MessageType.video
                                      ? Icons.video_file_outlined
                                      : null,
                              size: 16,
                            )),
                            const TextSpan(text: " "),
                            TextSpan(
                                text: replyMessage.type == MessageType.image
                                    ? ((replyMessage as ImageMessage).text !=
                                                null &&
                                            (replyMessage as ImageMessage)
                                                .text!
                                                .isNotEmpty)
                                        ? (replyMessage as ImageMessage).text ??
                                            'Image'
                                        : "Image"
                                    : replyMessage.type == MessageType.video
                                        ? (replyMessage as VideoMessage).text !=
                                                    null &&
                                                (replyMessage as VideoMessage)
                                                    .text!
                                                    .isNotEmpty
                                            ? (replyMessage as VideoMessage)
                                                .text
                                            : "Video"
                                        : "Video",
                                style: const TextStyle(color: Colors.black))
                          ]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      ]))
                ],
              )
            : ComputedMessage(
                message: replyMessage,
                isAuthor: true,
                shouldHideText: true,
                videoWidgetBuilder: videoWidgetBuilder,
                pdfWidgetBuilder: pdfWidgetBuilder,
                customWidgetBuilder: customWidgetBuilder,
              ),
      ),
    );
  }
}
