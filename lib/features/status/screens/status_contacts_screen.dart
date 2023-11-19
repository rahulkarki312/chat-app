import 'dart:io';

import 'package:chat_app/common/widgets/loader.dart';
import 'package:chat_app/features/status/controller/status_controller.dart';
import 'package:chat_app/features/status/screens/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/utils/utils.dart';
import '../../../models/status_model.dart';
import 'confirm_status_screen.dart';

class StatusContactsScreen extends ConsumerWidget {
  const StatusContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Text(
            'Stories',
            style: TextStyle(fontSize: 40),
          ),
        ),
        const Divider(),
        FutureBuilder<List<Status>>(
          future: ref.read(statusControllerProvider).getStatus(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var statusData = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, StatusScreen.routeName,
                            arguments: statusData);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            statusData.username,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 38,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                statusData.profilePic,
                              ),
                              radius: 30,
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
    );
  }
}
