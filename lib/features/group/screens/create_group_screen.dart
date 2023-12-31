import 'dart:io';

import 'package:chat_app/colors.dart';
import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/group/controller/group_controller.dart';
import 'package:chat_app/features/group/widgets/select_contacts_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const routeName = '/create-group-screen';
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    groupNameController.dispose();
  }

  void createGroup() {
    if (groupNameController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
            context,
            groupNameController.text,
            image!,
            ref.read(selectedGroupContacts),
          );
      ref.read(selectedGroupContacts.notifier).update((state) => []);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
        backgroundColor: appBarColor,
      ),
      body: Center(
          child: Column(
        children: [
          Stack(
            children: [
              image == null
                  ? const SizedBox(
                      height: 200,
                      child: CircleAvatar(
                        radius: 72,
                        backgroundColor: purple,
                        child: CircleAvatar(
                          radius: 68,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                'https://static.vecteezy.com/system/resources/previews/000/550/535/non_2x/user-icon-vector.jpg',
                              )),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 200,
                      child: CircleAvatar(
                        radius: 72,
                        backgroundColor: purple,
                        child: CircleAvatar(
                          radius: 68,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 64,
                            backgroundImage: FileImage(image!),
                          ),
                        ),
                      ),
                    ),
              Positioned(
                bottom: 15,
                left: 80,
                child: Card(
                  shape: const CircleBorder(),
                  child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo)),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: groupNameController,
              decoration: const InputDecoration(hintText: 'Enter Group Name'),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(8),
            child: const Text(
              'Select Contacts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SelectContactsGroup(),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: appBarColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
