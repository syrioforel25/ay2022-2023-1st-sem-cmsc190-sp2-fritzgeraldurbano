import 'package:bunkup/authenticationScreen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(39, 66, 147, 1.0),
        title: Text('Privacy Policy of BunkUP'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                      'BunkUP highly values your privacy and is committed to safeguarding your personal information. This Privacy Policy outlines how we collect, utilize, and protect your data when you use our Android mobile application. By using BunkUP, you accept the practices described in this policy.\n\n'
                      '1. Information We Collect:\n'
                      '- Personal Details: Name, email, password, profile picture, phone number, gender.\n'
                      '- Academic Information: College/university, degree program, batch year.\n'
                      '- Location: Municipality, city/province.\n'
                      '- Preferences: Rent budget, lease duration, number of roommates, cleanliness level, work/class schedule, sleep pattern, smoking/drinking habits, roommate interaction level, guest and pet preferences, cooking habits, noise level, interests.\n\n'
                      '2. How We Use Your Information:\n'
                      '- Matching: Your preferences are used to suggest potential roommates who align with your preferences.\n'
                      '- Communication: Contact information may be used to facilitate communication between matched users through WhatsApp.\n'
                      '- App Functionality: Information is utilized for features like viewing/editing profiles, seeing potential roommates, and managing matches.\n\n'
                      '3. Data Security:\n'
                      '- Limited Access: Only authorized personnel have access to user data.\n\n'
                      '4. Third-Party Access:\n'
                      '- WhatsApp Integration: Contact numbers may be shared with WhatsApp for communication purposes between matched users.\n'
                      '- No Other Third-Party Sharing: Your data is not shared with any other third parties.\n\n'
                      '5. User Control:\n'
                      '- Profile Editing: You can edit your profile information and preferences at any time.\n'
                      '- Account Management: For account-related inquiries or changes, please contact our support team at fmurbano@up.edu.ph.\n\n'
                      '6. Contact Us:\n'
                      '- For any inquiries or concerns about our privacy practices, please contact us at fmurbano@up.edu.ph.\n\n'
                      'By using BunkUP, you acknowledge that you have read and understood this Privacy Policy. We reserve the right to update this policy, so please review it periodically. Effective from [October 31, 2023].\n\n'
                      '[End of Privacy Policy]',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(RegistrationScreen());
              },
              child: Text('I Agree', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(39, 66, 147, 1.0),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}