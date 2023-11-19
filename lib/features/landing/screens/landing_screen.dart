import 'package:chat_app/colors.dart';
import 'package:chat_app/common/widgets/custom_button.dart';
import 'package:chat_app/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  void navigateToLoginScreen(BuildContext context) {
    Navigator.pushNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Welcome to ChatApp",
            style: TextStyle(fontSize: 33, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: size.height / 9),
          Image.asset(
            'assets/bg.png',
            height: MediaQuery.of(context).size.width * 0.8,
            width: size.width * 0.8,
          ),
          SizedBox(height: size.height / 9),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              'Read our Privacy Policy. Tap "Agree and Continue" to go to the home screen',
              style: TextStyle(color: greyColor),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
              width: size.width * 0.75,
              child: CustomButton(
                  text: "AGREE AND CONTINUE",
                  onPressed: () => navigateToLoginScreen(context)))
        ],
      )),
    );
  }
}
