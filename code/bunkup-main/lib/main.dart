import 'package:bunkup/authenticationScreen/login_screen.dart';
import 'package:bunkup/controllers/authentication_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    Get.put(AuthenticationController());
  });

  await Permission.notification.isDenied.then((value)
  {
    if(value){
      Permission.notification.request();
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BunkUP',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color.fromRGBO(245,246,249, 1.0),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
