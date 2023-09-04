import 'package:chat_app/colors.dart';
import 'package:chat_app/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country country) {
          setState(() {
            country = country;
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter your phone number"),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Text("ChatApp will need to verify your phone number"),
          TextButton(onPressed: pickCountry, child: const Text('Pick Country')),
          Row(
            children: [
              if (country != null) Text('+${country!.phoneCode}'),
              const SizedBox(width: 10),
              SizedBox(
                width: size.width * 0.7,
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(hintText: 'phone number'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.6,
          ),
          SizedBox(
            width: 90,
            child: CustomButton(
              onPressed: () {},
              text: 'NEXT',
            ),
          )
        ]),
      ),
    );
  }
}
