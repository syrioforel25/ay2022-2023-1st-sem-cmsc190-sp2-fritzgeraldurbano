import 'package:bunkup/authenticationScreen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/row_icon_caption_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 185,
          ),
          Image.asset(
            "images/logo_blue.png",
            width: 350,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Roommate Finding Application in UPLB",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
          ),
          const SizedBox(
            height: 30,
          ),
          RowWithIconAndCaption(
            icon: Icons.person_add,
            caption: "Create Account",
          ),
          RowWithIconAndCaption(
            icon: Icons.group,
            caption: "Match with Roommates",
          ),
          RowWithIconAndCaption(
            icon: Icons.mail,
            caption: "Contact Roommates",
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                Get.to(LoginScreen());
              },
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(39, 66, 147, 1.0),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
