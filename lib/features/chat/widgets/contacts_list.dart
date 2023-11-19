import 'package:chat_app/common/widgets/loader.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:chat_app/models/chat_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../colors.dart';
import '../../../info.dart';
import '../../../models/user_model.dart';
import '../../auth/controller/auth_controller.dart';
import '../../delegates/search_contacts_delegate.dart';
import '../../group/screens/create_group_screen.dart';
import '../../select_contacts/screens/select_contacts_screen.dart';
import '../screens/mobile_chat_screen.dart';

import '../../../models/group.dart' as model;

class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: InkWell(
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                        ),
                        const Text(
                          'Search Contacts   ',
                          style: TextStyle(fontSize: 20, color: greyColor),
                        ),
                        const Icon(Icons.search, color: greyColor),
                      ],
                    ),
                    onTap: () {
                      showSearch(
                          context: context,
                          delegate: SearchContactsDelegate(ref));
                    },
                  ),
                ),
                const SizedBox(width: 30),
                PopupMenuButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: blackColor,
                    ),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Text('Create A Group'),
                            onTap: () => Future(() => Navigator.pushNamed(
                                context, CreateGroupScreen.routeName)),
                          )
                        ]),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 0),
              child: Text(
                'Chats',
                style: TextStyle(fontSize: 40),
              ),
            ),
            const Row(
              children: [
                Expanded(child: Divider()),
                Text(
                  'Your Contacts  ',
                  style: TextStyle(fontSize: 18, color: greyColor),
                )
              ],
            ),
          ],
        ),
        ListView(
          shrinkWrap: true,
          children: [
            // the horizontal contacts listview
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  StreamBuilder<List<ChatContact>>(
                    stream: ref.watch(ChatControllerProvider).chatContacts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loader();
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var chatContactData = snapshot.data![index];
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MobileChatScreen.routeName,
                                  arguments: {
                                    'name': chatContactData.name,
                                    'uid': chatContactData.contactId,
                                    'isGroupChat': false,
                                    'profilePic': chatContactData.profilePic
                                  });
                            },
                            child: StreamBuilder<UserModel>(
                              stream: ref
                                  .read(authControllerProvider)
                                  .userDataById(chatContactData.contactId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox(
                                      width: 10, height: 10, child: Loader());
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2),
                                  child: Stack(
                                    children: [
                                      Card(
                                        elevation: 8,
                                        shape: const CircleBorder(),
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundColor: purple,
                                          child: CircleAvatar(
                                            radius: 32,
                                            backgroundColor: Colors.white,
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                chatContactData.profilePic,
                                              ),
                                              radius: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 12,
                                          left: 10,
                                          child: CircleAvatar(
                                            radius: 8,
                                            backgroundColor:
                                                snapshot.data!.isOnline
                                                    ? Colors.green
                                                    : Colors.transparent,
                                          ))
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                  StreamBuilder<List<model.Group>>(
                    stream: ref.watch(ChatControllerProvider).chatGroups(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loader();
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var groupData = snapshot.data![index];
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, MobileChatScreen.routeName,
                                      arguments: {
                                        'name': groupData.name,
                                        'uid': groupData.groupId,
                                        'isGroupChat': true,
                                        'profilePic': groupData.groupPic
                                      });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2),
                                  child: Card(
                                    elevation: 8,
                                    shape: const CircleBorder(),
                                    child: CircleAvatar(
                                      radius: 34,
                                      backgroundColor: purple,
                                      child: CircleAvatar(
                                        radius: 32,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            groupData.groupPic,
                                          ),
                                          radius: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const Divider(
              thickness: 1,
            ),
            StreamBuilder<List<model.Group>>(
              stream: ref.watch(ChatControllerProvider).chatGroups(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var groupData = snapshot.data![index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, MobileChatScreen.routeName,
                                arguments: {
                                  'name': groupData.name,
                                  'uid': groupData.groupId,
                                  'isGroupChat': true,
                                  'profilePic': groupData.groupPic
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: SizedBox(
                              height: 85,
                              child: Card(
                                elevation: 4,
                                child: ListTile(
                                  title: Text(
                                    groupData.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      groupData.lastMessage,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      groupData.groupPic,
                                    ),
                                    radius: 30,
                                  ),
                                  trailing: Text(
                                    DateFormat.Hm().format(groupData.timeSent),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // const Divider(color: dividerColor, indent: 85),
                      ],
                    );
                  },
                );
              },
            ),
            StreamBuilder<List<ChatContact>>(
              stream: ref.watch(ChatControllerProvider).chatContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var chatContactData = snapshot.data![index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, MobileChatScreen.routeName,
                                arguments: {
                                  'name': chatContactData.name,
                                  'uid': chatContactData.contactId,
                                  'isGroupChat': false,
                                  'profilePic': chatContactData.profilePic
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: SizedBox(
                              height: 85,
                              child: Card(
                                elevation: 4,
                                child: ListTile(
                                  title: Text(
                                    chatContactData.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      chatContactData.lastMessage,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  leading: StreamBuilder<UserModel>(
                                    stream: ref
                                        .read(authControllerProvider)
                                        .userDataById(
                                            chatContactData.contactId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox(
                                            width: 10,
                                            height: 10,
                                            child: Loader());
                                      }
                                      return Stack(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              chatContactData.profilePic,
                                            ),
                                            radius: 30,
                                          ),
                                          Positioned(
                                              bottom: 5,
                                              left: 1,
                                              child: CircleAvatar(
                                                radius: 8,
                                                backgroundColor:
                                                    snapshot.data!.isOnline
                                                        ? Colors.green
                                                        : Colors.transparent,
                                              ))
                                        ],
                                      );
                                    },
                                  ),
                                  trailing: Text(
                                    DateFormat.Hm()
                                        .format(chatContactData.timeSent),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // const Divider(color: dividerColor, indent: 85),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
