import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/features/chat/screens/mobile_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactsRepositoryProvider =
    Provider((ref) => SelectContactRepository(FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository(this.firestore);

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;

      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());

        // to replace the blank spaces and hyphens - in the phone num with no space
        String selectedPhoneNum =
            selectedContact.phones[0].number.replaceAll(RegExp('[-, ]'), '');
        print(selectedPhoneNum);
        print(userData.phoneNumber);

        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          if (context.mounted) {
            Navigator.pushNamed(context, MobileChatScreen.routeName,
                arguments: {'name': userData.name, 'uid': userData.uid});
            return;
          }
        }
      }
      if (!isFound) {
        if (context.mounted) {
          showSnackBar(
              context: context, content: "This person is not in this app");
        }
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
