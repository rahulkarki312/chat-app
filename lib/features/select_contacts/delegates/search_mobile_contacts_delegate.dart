import 'package:chat_app/features/select_contacts/controller/select_contact_controller.dart';
import 'package:chat_app/features/select_contacts/repository/select_contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/error.dart';
import '../../../common/widgets/loader.dart';

class SearchMobileContactsDelegate extends SearchDelegate {
  final WidgetRef ref;

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(SelectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  SearchMobileContactsDelegate(this.ref);

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
    return FutureBuilder(
      future: ref.read(selectContactsRepositoryProvider).getContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Contact> matchQueryContacts = [];
          for (var contact in snapshot.data!) {
            if (contact.name
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) {
              matchQueryContacts.add(contact);
            }
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: matchQueryContacts.length,
            itemBuilder: (context, index) {
              var contact = matchQueryContacts[index];
              return InkWell(
                onTap: () => selectContact(ref, contact, context),
                child: ListTile(
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(fontSize: 18),
                    ),
                    leading: contact.photo == null
                        ? null
                        : CircleAvatar(
                            backgroundImage: MemoryImage(contact.photo!),
                            radius: 30,
                          )),
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: ref.read(selectContactsRepositoryProvider).getContacts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<Contact> matchQueryContacts = [];
          for (var contact in snapshot.data!) {
            if (contact.name
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) {
              matchQueryContacts.add(contact);
            }
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: matchQueryContacts.length,
            itemBuilder: (context, index) {
              var contact = matchQueryContacts[index];
              return InkWell(
                onTap: () => selectContact(ref, contact, context),
                child: ListTile(
                    title: Text(
                      contact.displayName,
                      style: const TextStyle(fontSize: 18),
                    ),
                    leading: contact.photo == null
                        ? null
                        : CircleAvatar(
                            backgroundImage: MemoryImage(contact.photo!),
                            radius: 30,
                          )),
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
    );
  }
}
