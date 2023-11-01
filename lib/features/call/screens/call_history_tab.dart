import 'package:chat_app/common/widgets/loader.dart';
import 'package:chat_app/features/call/controller/call_controller.dart';
import 'package:chat_app/features/call/repository/call_repository.dart';
import 'package:chat_app/models/call_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CallHistoryTab extends ConsumerWidget {
  static const routeName = '/call-history-screen';
  const CallHistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<List<CallHistory>>(
      future: ref.read(callControllerProvider).getCallHistory,
      builder: (context, snapshot) {
        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No calls made yet"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        } else {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var callHistory = snapshot.data![index];
                final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                String username;
                String profilePic;
                bool isCalledByCurrentUser = true;
                if (callHistory.senderUserId == currentUserId) {
                  username = callHistory.receiverUserName;
                  profilePic = callHistory.receiverProfilePic;
                } else {
                  username = callHistory.senderUserName;
                  profilePic = callHistory.senderProfilePic;
                  isCalledByCurrentUser = false;
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                      title: Row(
                        children: [
                          Text("$username "),
                          Icon(isCalledByCurrentUser
                              ? Icons.call_made
                              : Icons.call_received)
                        ],
                      ),
                      trailing:
                          Text(DateFormat.yMEd().format(callHistory.callDate)),
                      leading: CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(profilePic))),
                );
              });
        }
      },
    );
  }
}
