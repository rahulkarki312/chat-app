import 'package:chat_app/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        text,
        style: TextStyle(color: blackColor),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          primary: tabColor, minimumSize: const Size(double.infinity, 50)),
    );
  }
}
