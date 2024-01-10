import 'package:bunkup/authenticationScreen/privacy_policy_screen.dart';
import 'package:bunkup/authenticationScreen/registration_screen.dart';
import 'package:bunkup/controllers/authentication_controller.dart';
import 'package:bunkup/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool showProgressBar = false;
  var controllerAuth = AuthenticationController.authController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 200,
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
                height: 20,
              ),
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(
                height: 28,
              ),
              //Email
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: emailTextEditingController,
                  labelText: "Email",
                  iconData: Icons.email_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Password
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: passwordTextEditingController,
                  labelText: "Password",
                  iconData: Icons.lock_outline,
                  isObscure: true,
                ),
              ),
              //Login Button
              const SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 36,
                height: 50,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(39, 66, 147, 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    )),
                child: InkWell(
                  onTap: () async {
                    if (emailTextEditingController.text.trim().isNotEmpty &&
                        passwordTextEditingController.text.trim().isNotEmpty) {
                      setState(() {
                        showProgressBar = true;
                      });

                      await controllerAuth.loginUser(
                          emailTextEditingController.text.trim(),
                          passwordTextEditingController.text.trim());

                      setState(() {
                        showProgressBar = false;
                      });
                    } else {
                      Get.snackbar("Email/Password is Missing",
                          "Please fill out all necessary fields.");
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              //No account (Sign Up Button)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(PrivacyPolicyScreen());
                    },
                    child: const Text(
                      "Sign up here.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(39, 66, 147, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              showProgressBar == true
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(39, 66, 147, 1.0)),
                    )
                  : Container(),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
