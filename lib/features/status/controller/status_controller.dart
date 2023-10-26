import 'dart:io';

import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/status/repository/status_repository.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../../../models/status_model.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepository = ref.watch(statusRepositoryProvider);
  return StatusController(statusRepository: statusRepository, ref: ref);
});

class StatusController {
  final StatusRepository statusRepository;
  final ProviderRef ref;

  StatusController({required this.statusRepository, required this.ref});

  void addStatus(File file, BuildContext context) {
    ref.watch(userDataAuthProvider).whenData((value) =>
        statusRepository.uploadStatus(
            username: value!.name,
            profilePic: value.profilePic,
            phoneNumber: value.phoneNumber,
            statusImage: file,
            context: context));
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statuses = await statusRepository.getStatus(context);
    return statuses;
  }
}
