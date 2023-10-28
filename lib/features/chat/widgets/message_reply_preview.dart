import 'package:chat_app/common/providers/message_reply_provider.dart';
import 'package:chat_app/features/chat/widgets/display_text_image_gif.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';

class MessageReplyPreview extends ConsumerWidget {
  final String receiverUserId;
  final bool isGroupChat;
  const MessageReplyPreview(
      {super.key, required this.receiverUserId, this.isGroupChat = false});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  Future<String> getReceiverUsername() async {
    var userDataMap = await FirebaseFirestore.instance
        .collection('users')
        .doc(receiverUserId)
        .get();
    var receiverUserData = UserModel.fromMap(userDataMap.data()!);
    return receiverUserData.name;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      width: 350,
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Column(children: [
        Row(
          children: [
            Expanded(
                child: FutureBuilder(
                    future: getReceiverUsername(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? const Text('')
                          : Text(
                              messageReply!.isMe
                                  ? 'Me'
                                  : isGroupChat
                                      ? ''
                                      : snapshot.data!,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            );
                    })),
            GestureDetector(
              child: const Icon(
                Icons.close,
                size: 16,
              ),
              onTap: () => cancelReply(ref),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        DisplayTextImageGIF(
          message: messageReply!.message,
          type: messageReply.messageEnum,
        )
      ]),
    );
  }
}
