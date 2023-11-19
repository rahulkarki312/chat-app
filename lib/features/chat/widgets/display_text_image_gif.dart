// import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/common/enums/message_enum.dart';
import 'package:chat_app/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class DisplayTextImageGIF extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayTextImageGIF(
      {super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    audioPlayer.setUrl(
        'https://codeskulptor-demos.commondatastorage.googleapis.com/GalaxyInvaders/theme_01.mp3');

    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(
                builder: (context, setState) => IconButton(
                    constraints: const BoxConstraints(minWidth: 120),
                    onPressed: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                        setState(() => isPlaying = false);
                      } else {
                        print('\n message = $message \n');
                        await audioPlayer.play();
                        setState(() => isPlaying = true);
                      }
                    },
                    icon: Icon(
                        isPlaying ? Icons.pause_circle : Icons.play_circle)),
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
