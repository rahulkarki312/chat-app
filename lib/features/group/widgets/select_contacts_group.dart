import 'package:chat_app/common/widgets/error.dart';
import 'package:chat_app/common/widgets/loader.dart';
import 'package:chat_app/features/select_contacts/controller/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// stateProvider is a type of provider that can change(updated)
final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.notifier)
        .update((previousContactList) => [...previousContactList, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
        data: (contactsList) => Expanded(
              child: ListView.builder(
                  itemCount: contactsList.length,
                  itemBuilder: (context, index) {
                    final contact = contactsList[index];
                    return InkWell(
                      onTap: () => selectContact(index, contact),
                      child: ListTile(
                          leading: selectedContactsIndex.contains(index)
                              ? IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.done))
                              : null,
                          title: Text(
                            contact.displayName,
                            style: const TextStyle(fontSize: 18),
                          )),
                    );
                  }),
            ),
        error: (error, trace) => ErrorScreen(error: error.toString()),
        loading: () => const Loader());
  }
}
