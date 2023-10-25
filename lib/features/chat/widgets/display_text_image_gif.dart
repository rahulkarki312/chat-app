import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/common/enums/message_enum.dart';
import 'package:chat_app/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGIF(
      {super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16),
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(
                videoUrl: message,
              )
            : type == MessageEnum.gif
                ? CachedNetworkImage(
                    imageUrl: message,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : CachedNetworkImage(
                    imageUrl: message,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
  }
}
