import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/call/repository/call_repository.dart';
import 'package:chat_app/models/call.dart';
import 'package:chat_app/models/call_history.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.watch(callRepositoryProvider);
  return CallController(
      callRepository: callRepository, ref: ref, auth: FirebaseAuth.instance);
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;

  CallController(
      {required this.callRepository, required this.ref, required this.auth});

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void makeCall(BuildContext context, String receiverName, String receiverId,
      String receiverProfilePic, bool isGroupChat) {
    String callId = const Uuid().v1();
    ref.read(userDataAuthProvider).whenData((value) {
      Call senderCallData = Call(
          callerId: auth.currentUser!.uid,
          callerName: value!.name,
          callerPic: value.profilePic,
          receiverId: receiverId,
          receiverName: receiverName,
          receiverPic: receiverProfilePic,
          callId: callId,
          hasDialled: true);

      Call receiverCallData = Call(
          callerId: auth.currentUser!.uid,
          callerName: value.name,
          callerPic: value.profilePic,
          receiverId: receiverId,
          receiverName: receiverName,
          receiverPic: receiverProfilePic,
          callId: callId,
          hasDialled: false);
      if (isGroupChat) {
        callRepository.makeGroupCall(senderCallData, receiverCallData, context);
      } else {
        callRepository.makeCall(senderCallData, receiverCallData, context);
      }
    });
  }

  void endCall(String callerId, String receiverId, BuildContext context,
      bool isGroupChat) {
    if (isGroupChat) {
      callRepository.endGroupCall(callerId, receiverId, context);
    } else {
      callRepository.endCall(callerId, receiverId, context);
    }
  }

  Future<List<CallHistory>> get getCallHistory {
    return callRepository.callHistory;
  }
}
