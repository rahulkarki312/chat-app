import 'package:chat_app/common/widgets/loader.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/call/controller/call_controller.dart';
import 'package:chat_app/features/call/screens/call_pickup_screen.dart';
import 'package:chat_app/features/chat/widgets/bottom_chat_field.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../colors.dart';
import '../widgets/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const routeName = '/mobile-chat-screen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;

  const MobileChatScreen(
      {required this.name,
      required this.uid,
      required this.isGroupChat,
      required this.profilePic});

  void makeCall(WidgetRef ref, BuildContext context) {
    ref
        .read(callControllerProvider)
        .makeCall(context, name, uid, profilePic, isGroupChat);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CallPickupScreen(
      isGroupChat: isGroupChat,
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarColor,
          // StreamBuilder is used here since we need to continously check if the selected user is onilne (here using authRepositoryProvider)
          title: isGroupChat
              ? Text(name)
              : StreamBuilder<UserModel>(
                  stream: ref.read(authControllerProvider).userDataById(uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loader();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('$name '),
                            snapshot.data!.isOnline
                                ? const CircleAvatar(
                                    backgroundColor: Colors.green,
                                    radius: 7,
                                  )
                                : const Text('')
                          ],
                        ),
                        Text(
                          snapshot.data!.isOnline ? 'online' : 'offline',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal),
                        )
                      ],
                    );
                  },
                ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => makeCall(ref, context),
              icon: const Icon(Icons.video_call),
            ),
            IconButton(
              onPressed: () => makeCall(ref, context),
              icon: const Icon(Icons.call),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatList(receiverUserId: uid, isGroupChat: isGroupChat),
            ),
            BottomChatField(receiverUserId: uid, isGroupChat: isGroupChat),
          ],
        ),
      ),
    );
  }
}
