import 'package:chat_app/common/repository/common_firebase_storage_repository.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/auth/screens/otp_screen.dart';
import 'package:chat_app/features/auth/screens/user_information_screen.dart';
import 'package:chat_app/models/status_model.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/mobile_layout_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'dart:io';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    // here ref is of type ProviderRef , in which a provider interacts with another provider
    // In Consumer side (Widgets that use the provider), WidgetRef is used, in which a widget interacts with the provider
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, phoneNumber) async {
    try {
      auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: (String verificationId, int? resendToken) async {
          Navigator.pushNamed(context, OTPScreen.routeName,
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformationScreen.routeName, (route) => false);

      // pushNamedAndRemoveUntil doesn't let the user to go to the previous screen (since already authenticated, can't go back to login/otp page)
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          'https://www.nswtreeworks.com.au/wp-content/uploads/2017/04/dummy_person.png';
      if (profilePic != null) {
        // stores the file(image) in firebase's storage
        photoUrl = await ref
            .read(CommonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase('profilePic/$uid', profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoUrl,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber.toString(),
          groupId: []);

      firestore.collection('users').doc(uid).set(user
          .toMap()); // stores the user info to firebase's firestore database inside 'users' collection under 'uid'
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
            (route) => false);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

// Stream type lets us keep continous track of data (here, user's data)
  Stream<UserModel> userData(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
    // ultimately returns userdata with the given userId
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline});
  }

  void updateUserInfo(
      {required String name,
      required File? profilePic,
      required ProviderRef ref,
      required BuildContext context}) async {
    String uid = auth.currentUser!.uid;
    String? photoUrl;
    if (profilePic != null) {
      photoUrl = await ref
          .read(CommonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('profilePic/$uid', profilePic);
    }

    if (profilePic == null) {
      // only update the name if no pic is selected (same old photo used)
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({'name': name});
    } else {
      // update both the name and pic of the user
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({'name': name, 'profilePic': photoUrl});
    }

    // update status to change the user's info in database
    final statusSnapshot =
        await firestore.collection('status').where('uid', isEqualTo: uid).get();
    if (statusSnapshot.docs.isNotEmpty) {
      await firestore
          .collection('status')
          .doc(statusSnapshot.docs[0].id)
          .update({'username': name, 'profilePic': photoUrl});
    }

    // update CallHistory to update the username and profilePic

    //if the currentUser had made the call (update senderUserData)
    final senderDataSnapshots = await firestore
        .collection('callHistory')
        .where('senderUserId', isEqualTo: uid)
        .get();
    if (senderDataSnapshots.docs.isNotEmpty) {
      for (var doc in senderDataSnapshots.docs) {
        await firestore
            .collection('callHistory')
            .doc(doc.id)
            .update({'senderUserName': name, 'senderProfilePic': photoUrl});
      }
    }

    //if the currentUser had received the call (update receiverUserData)
    final receiverDataSnapshots = await firestore
        .collection('callHistory')
        .where('receiverUserId', isEqualTo: uid)
        .get();

    if (receiverDataSnapshots.docs.isNotEmpty) {
      for (var doc in receiverDataSnapshots.docs) {
        await firestore
            .collection('callHistory')
            .doc(doc.id)
            .update({'receiverUserName': name, 'receiverProfilePic': photoUrl});
      }
    }
  }
}
