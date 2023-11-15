import 'dart:io';

import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/features/auth/controller/auth_controller.dart';
import 'package:chat_app/features/call/screens/call_history_tab.dart';
import 'package:chat_app/features/delegates/search_contacts_delegate.dart';
import 'package:chat_app/features/edit/screens/edit_info_screen.dart';

import 'package:chat_app/features/group/screens/create_group_screen.dart';
import 'package:chat_app/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:chat_app/features/status/screens/confirm_status_screen.dart';
import 'package:chat_app/features/status/screens/status_contacts_screen.dart';
import 'package:flutter/material.dart';
import '../colors.dart';
import '../features/chat/widgets/contacts_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  int currentPageIndex = 0;
  // late TabController tabBarController;
  @override
  void initState() {
    super.initState();
    // tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          height: 60,
          indicatorShape: const CircleBorder(),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          indicatorColor: purple,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              icon: Icon(Icons.home_outlined),
              label: 'Contacts ',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.photo,
                color: Colors.white,
              ),
              icon: Icon(Icons.photo_outlined),
              label: 'Stories',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.phone,
                color: Colors.white,
              ),
              icon: Icon(Icons.phone_outlined),
              label: 'Call History',
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              icon: Icon(Icons.person_outlined),
              label: 'Edit Info',
            ),
          ]),
      body: const <Widget>[
        ContactsList(),
        StatusContactsScreen(),
        CallHistoryTab(),
        EditInfoScreen(),
      ][currentPageIndex],
      floatingActionButton: currentPageIndex == 2 || currentPageIndex == 3
          ? null
          : FloatingActionButton(
              backgroundColor: appBarColor,
              child: Icon(
                currentPageIndex == 0 ? Icons.add : Icons.add_photo_alternate,
                color: Colors.white,
              ),
              onPressed: () async {
                if (currentPageIndex == 0) {
                  Navigator.pushNamed(context, SelectContactsScreen.routeName);
                } else {
                  File? pickedImage = await pickImageFromGallery(context);
                  if (pickedImage != null && context.mounted) {
                    Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                        arguments: pickedImage);
                  }
                }
              }),
    );
  }
}
