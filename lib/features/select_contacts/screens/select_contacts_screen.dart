import 'package:chat_app/colors.dart';
import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/common/widgets/loader.dart';
import 'package:chat_app/features/select_contacts/controller/select_contact_controller.dart';
import 'package:chat_app/features/select_contacts/delegates/search_mobile_contacts_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_contacts/contact.dart';

class SelectContactsScreen extends ConsumerWidget {
  static const routeName = 'select-contacts-screen';
  const SelectContactsScreen({super.key});

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(SelectContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text('Select Contact'),
          actions: [
            IconButton(
                constraints: const BoxConstraints(minWidth: 100),
                onPressed: () => showSearch(
                    context: context,
                    delegate: SearchMobileContactsDelegate(ref)),
                icon: const Icon(Icons.search)),
          ]),
      body: ref.watch(getContactsProvider).when(
          data: (contactsList) => ListView.builder(
              itemCount: contactsList.length,
              itemBuilder: (context, index) {
                final contact = contactsList[index];
                return InkWell(
                  onTap: () => selectContact(ref, contact, context),
                  child: Column(
                    children: [
                      ListTile(
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
                      const Divider(thickness: 2)
                    ],
                  ),
                );
              }),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => const Loader()),
    );
  }
}
