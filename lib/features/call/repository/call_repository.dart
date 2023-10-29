import 'dart:io';

import 'package:chat_app/common/repository/common_firebase_storage_repository.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/call/screens/call_screen.dart';
import 'package:chat_app/models/call.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../models/group.dart' as model;

final Provider callRepositoryProvider = Provider<CallRepository>(
    (ref) => CallRepository(FirebaseFirestore.instance, FirebaseAuth.instance));

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository(this.firestore, this.auth);

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void makeCall(
      Call senderCallData, Call receiverCallData, BuildContext context) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(receiverCallData.receiverId)
          .set(receiverCallData.toMap());
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CallScreen(
                    channelId: senderCallData.callId,
                    call: senderCallData,
                    isGroupChat: false)));
      }
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }

  void endCall(String callerId, String receiverId, BuildContext context) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }

  void makeGroupCall(
      Call senderCallData, Call receiverCallData, BuildContext context) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      var groupSnapshot = await firestore
          .collection('groups')
          .doc(senderCallData.receiverId)
          .get();
      model.Group group = model.Group.fromMap(groupSnapshot.data()!);

      for (var id in group.membersUid) {
        await firestore
            .collection('call')
            .doc(id)
            .set(receiverCallData.toMap());
      }
      if (context.mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CallScreen(
                    channelId: senderCallData.callId,
                    call: senderCallData,
                    isGroupChat: true)));
      }
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }

  void endGroupCall(
      String callerId, String receiverId, BuildContext context) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      var groupSnapshot =
          await firestore.collection('groups').doc(receiverId).get();
      model.Group group = model.Group.fromMap(groupSnapshot.data()!);

      for (var id in group.membersUid) {
        await firestore.collection('call').doc(id).delete();
      }
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }
}
