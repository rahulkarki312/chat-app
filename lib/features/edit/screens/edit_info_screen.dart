import 'dart:io';

import 'package:chat_app/colors.dart';
import 'package:chat_app/common/widgets/loader.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';

class EditInfoScreen extends ConsumerStatefulWidget {
  const EditInfoScreen({super.key});

  @override
  ConsumerState<EditInfoScreen> createState() => _EditInfoScreenState();
}

class _EditInfoScreenState extends ConsumerState<EditInfoScreen> {
  void toggleTheme() {
    setState(() {});
  }

  final TextEditingController userNameController = TextEditingController();
  File? image;
  late UserModel currentUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void saveForm() async {
    ref
        .read(authControllerProvider)
        .updateUserInfo(context, userNameController.text, image);
    showSnackBar(context: context, content: 'Updated Successfully !');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 30),
        const Text(
          ' Edit Your Profile',
          style: TextStyle(fontSize: 40),
        ),
        const Divider(),
        const SizedBox(height: 25),
        FutureBuilder(
          future: ref.read(authControllerProvider).getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            currentUser = snapshot.data!;
            return Column(
              children: [
                const SizedBox(height: 10),
                Stack(
                  children: [
                    image == null
                        ? SizedBox(
                            height: 200,
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: purple,
                              child: CircleAvatar(
                                radius: 67,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 64,
                                  backgroundImage:
                                      NetworkImage(currentUser.profilePic),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 200,
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: purple,
                              child: CircleAvatar(
                                radius: 67,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 64,
                                  backgroundImage: FileImage(image!),
                                ),
                              ),
                            ),
                          ),
                    Positioned(
                      bottom: 20,
                      left: 80,
                      child: Card(
                        shape: const CircleBorder(),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: blackColor,
                                size: 25,
                              )),
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: userNameController..text = currentUser.name,
                  ),
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: appBarColor,
                        elevation: 6,
                        shape: const CircleBorder(),
                        fixedSize: const Size(60, 60)),
                    onPressed: saveForm,
                    child: const Text('save')),
                const SizedBox(height: 55),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                    // const ChangeThemeButton()
                  ],
                )
              ],
            );
          },
        ),
      ],
    );
  }
}

class ChangeThemeButton extends ConsumerStatefulWidget {
  const ChangeThemeButton({super.key});

  @override
  ConsumerState<ChangeThemeButton> createState() => _ChangeThemeButtonState();
}

class _ChangeThemeButtonState extends ConsumerState<ChangeThemeButton> {
  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: ref.read(themeProvider).isDarkMode,
      onChanged: (value) {
        ref.read(themeProvider).toggleTheme(value);
        setState(() {});
      },
    );
  }
}
