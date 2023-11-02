import 'package:chat_app/common/utils/utils.dart';
import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/common/widgets/loader.dart';
import 'package:chat_app/features/chat/controller/chat_controller.dart';
import 'package:chat_app/models/chat_contact.dart';
import 'package:chat_app/models/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../chat/screens/mobile_chat_screen.dart';

class SearchContactsDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchContactsDelegate(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder(
          future: ref.read(ChatControllerProvider).getGroupsAsFuture(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Group> matchQueryGroupContacts = [];
              for (var chatGroup in snapshot.data!) {
                if (chatGroup.name
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
                  matchQueryGroupContacts.add(chatGroup);
                }
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: matchQueryGroupContacts.length,
                itemBuilder: (context, index) {
                  var group = matchQueryGroupContacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(group.groupPic)),
                    title: Text(group.name),
                    onTap: () {
                      Navigator.pushNamed(context, MobileChatScreen.routeName,
                          arguments: {
                            'name': group.name,
                            'uid': group.groupId,
                            'isGroupChat': true,
                            'profilePic': group.groupPic
                          });
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              // showSnackBar(context: context, content: snapshot.error.toString());
              return ErrorScreen(error: snapshot.error.toString());
            } else {
              return const Loader();
            }
          },
        ),
        FutureBuilder(
          future: ref.read(ChatControllerProvider).getChatContactsAsFuture(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<ChatContact> matchQueryContacts = [];
              for (var chatContact in snapshot.data!) {
                if (chatContact.name
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
                  matchQueryContacts.add(chatContact);
                }
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: matchQueryContacts.length,
                itemBuilder: (context, index) {
                  var chatContact = matchQueryContacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(chatContact.profilePic)),
                    title: Text(chatContact.name),
                    onTap: () {
                      Navigator.pushNamed(context, MobileChatScreen.routeName,
                          arguments: {
                            'name': chatContact.name,
                            'uid': chatContact.contactId,
                            'isGroupChat': false,
                            'profilePic': chatContact.profilePic
                          });
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              // showSnackBar(context: context, content: snapshot.error.toString());
              return ErrorScreen(error: snapshot.error.toString());
            } else {
              return const Loader();
            }
          },
        ),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder(
          future: ref.read(ChatControllerProvider).getGroupsAsFuture(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<Group> matchQueryGroupContacts = [];
              for (var chatGroup in snapshot.data!) {
                if (chatGroup.name
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
                  matchQueryGroupContacts.add(chatGroup);
                }
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: matchQueryGroupContacts.length,
                itemBuilder: (context, index) {
                  var group = matchQueryGroupContacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(group.groupPic)),
                    title: Text(group.name),
                    onTap: () {
                      Navigator.pushNamed(context, MobileChatScreen.routeName,
                          arguments: {
                            'name': group.name,
                            'uid': group.groupId,
                            'isGroupChat': true,
                            'profilePic': group.groupPic
                          });
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              // showSnackBar(context: context, content: snapshot.error.toString());
              return ErrorScreen(error: snapshot.error.toString());
            } else {
              return const Loader();
            }
          },
        ),
        FutureBuilder(
          future: ref.read(ChatControllerProvider).getChatContactsAsFuture(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List<ChatContact> matchQueryContacts = [];
              for (var chatContact in snapshot.data!) {
                if (chatContact.name
                    .toLowerCase()
                    .contains(query.toLowerCase())) {
                  matchQueryContacts.add(chatContact);
                }
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: matchQueryContacts.length,
                itemBuilder: (context, index) {
                  var chatContact = matchQueryContacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(chatContact.profilePic)),
                    title: Text(chatContact.name),
                    onTap: () {
                      Navigator.pushNamed(context, MobileChatScreen.routeName,
                          arguments: {
                            'name': chatContact.name,
                            'uid': chatContact.contactId,
                            'isGroupChat': false,
                            'profilePic': chatContact.profilePic
                          });
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              // showSnackBar(context: context, content: snapshot.error.toString());
              return ErrorScreen(error: snapshot.error.toString());
            } else {
              return const Loader();
            }
          },
        ),
      ],
    );
  }
}
