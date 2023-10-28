import 'package:chat_app/colors.dart';
import 'package:chat_app/common/enums/message_enum.dart';
import 'package:chat_app/features/chat/widgets/display_text_image_gif.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isGroupChat;

  const SenderMessageCard(
      {super.key,
      required this.message,
      required this.date,
      required this.type,
      required this.onRightSwipe,
      required this.repliedText,
      required this.username,
      required this.repliedMessageType,
      this.isGroupChat = false});

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                    padding: type == MessageEnum.text
                        ? const EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            top: 5, left: 5, right: 5, bottom: 25),
                    child: Column(
                      children: [
                        // if the message was replied to
                        if (isReplying) ...[
                          Text(
                            username,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: backgroundColor.withOpacity(0.5),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            child: DisplayTextImageGIF(
                                message: repliedText, type: repliedMessageType),
                          ),
                          const SizedBox(
                            height: 8,
                          )
                        ],
                        DisplayTextImageGIF(message: message, type: type),
                      ],
                    )),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
