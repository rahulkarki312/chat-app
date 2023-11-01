import 'package:chat_app/features/call/controller/call_controller.dart';
import 'package:chat_app/models/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'call_screen.dart';

class CallPickupScreen extends ConsumerWidget {
  final Widget scaffold;
  final bool isGroupChat;
  const CallPickupScreen(
      {super.key, required this.scaffold, required this.isGroupChat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
        stream: ref.watch(callControllerProvider).callStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.data() != null) {
            Call call =
                Call.fromMap(snapshot.data!.data() as Map<String, dynamic>);
            if (!call.hasDialled) {
              // call-accepting screen
              return Scaffold(
                body: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Incoming Call',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        const SizedBox(height: 50),
                        CircleAvatar(
                            backgroundImage: NetworkImage(call.callerPic),
                            radius: 60),
                        const SizedBox(height: 50),
                        Text(
                          call.callerName,
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 85),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  ref.read(callControllerProvider).endCall(
                                      call.callerId,
                                      call.receiverId,
                                      context,
                                      isGroupChat);
                                },
                                icon: const Icon(
                                  Icons.call_end,
                                  color: Colors.redAccent,
                                  size: 35,
                                )),
                            const SizedBox(width: 85),
                            IconButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CallScreen(
                                            channelId: call.callId,
                                            call: call,
                                            isGroupChat: false))),
                                icon: const Icon(
                                  Icons.call,
                                  color: Colors.green,
                                  size: 35,
                                ))
                          ],
                        )
                      ],
                    )),
              );
            }
          }
          return scaffold;
        });
  }
}
