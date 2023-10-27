import 'dart:io';

import 'package:chat_app/common/repository/common_firebase_storage_repository.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../models/group.dart' as model;

final Provider groupRepositoryProvider = Provider<GroupRepository>((ref) =>
    GroupRepository(FirebaseFirestore.instance, FirebaseAuth.instance, ref));

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository(this.firestore, this.auth, this.ref);

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContact) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContact.length; i++) {
        // select phoneNumbers that exist in firebase (our app)
        var userCollection = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: selectedContact[i]
                    .phones[0]
                    .number
                    .replaceAll(RegExp('[-, ]'), ''))
            .get();
        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();
      String profileUrl = await ref
          .read(CommonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('group/$groupId', profilePic);
      model.Group group = model.Group(
          senderId: auth.currentUser!.uid,
          name: name,
          groupId: groupId,
          lastMessage: '',
          groupPic: profileUrl,
          membersUid: [...uids, auth.currentUser!.uid],
          timeSent: DateTime.now());
      firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }
}
