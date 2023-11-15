import 'dart:io';
import 'package:chat_app/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:chat_app/models/user_model.dart';

// NOTE: providers should always be global in RiverPod

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  // ref.watch(authRepositoryProvider) is equivalent to Provider.of<authRepositoryProvider>(context, listen:true)
  return AuthController(authRepository: authRepository, ref: ref);
});

// this provider is used to check if while restarting the app, we stay in the home(contacts) screen  or landing screen, if logged out/not logged in (see main.dart)
final userDataAuthProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider);
  return authController.getUserData();
});

class AuthController {
  final AuthRepository authRepository;
  final ProviderRef ref;
  AuthController({
    required this.authRepository,
    required this.ref,
  });

  Future<UserModel?> getUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String verificationId, String userOTP) {
    authRepository.verifyOTP(
        context: context, verificationId: verificationId, userOTP: userOTP);
  }

  void saveUserDataToFirebase(
      BuildContext context, String name, File? profilePic) {
    authRepository.saveUserDataToFirebase(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }

  Stream<UserModel> userDataById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }

  void updateUserInfo(BuildContext context, String name, File? profilePic) {
    authRepository.updateUserInfo(
        name: name, profilePic: profilePic, ref: ref, context: context);
  }
}
