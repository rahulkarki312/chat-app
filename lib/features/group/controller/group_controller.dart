import 'dart:io';

import 'package:chat_app/features/group/repository/group_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider groupControllerProvider = Provider((ref) {
  final groupRepository = ref.read(groupRepositoryProvider);
  return GroupController(groupRepository, ref);
});

class GroupController {
  final GroupRepository groupRespository;
  final ProviderRef ref;

  GroupController(this.groupRespository, this.ref);

  void createGroup(BuildContext context, String name, File profilePic,
      List<Contact> selectedContact) {
    groupRespository.createGroup(context, name, profilePic, selectedContact);
  }
}
