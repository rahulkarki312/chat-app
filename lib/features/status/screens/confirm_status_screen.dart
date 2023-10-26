import 'dart:io';

import 'package:chat_app/colors.dart';
import 'package:chat_app/features/status/controller/status_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  static const routeName = "/confirm-status-screen";
  final File file;
  const ConfirmStatusScreen({super.key, required this.file});

  void addStatus(WidgetRef ref, BuildContext context) {
    ref.read(statusControllerProvider).addStatus(file, context);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
          child: AspectRatio(
        aspectRatio: 9 / 16,
        child: Image.file(file),
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tabColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
        onPressed: () {
          addStatus(ref, context);
        },
      ),
    );
  }
}
