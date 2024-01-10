import 'package:bunkup/pushNotificationSystem/push_notification_system.dart';
import 'package:bunkup/tabScreens/like_screen.dart';
import 'package:bunkup/tabScreens/match_screen.dart';
import 'package:bunkup/tabScreens/swipe_screen.dart';
import 'package:bunkup/tabScreens/user_details_screen.dart';
import 'package:bunkup/tabScreens/view_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenIndex = 0;
  List tabScreenList = [
    SwipeScreen(),
    ViewScreen(),
    LikeScreen(),
    MatchScreen(),
    UserDetailsScreen(userID: FirebaseAuth.instance.currentUser!.uid),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotificationSystem notificationSystem = PushNotificationSystem();
    notificationSystem.generateDeviceRegistrationToken();
    notificationSystem.whenNotificationReceived(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (indexNumber){
          setState(() {
            screenIndex = indexNumber;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromRGBO(39, 66, 147, 1.0),
        unselectedItemColor: Colors.blueGrey,
        currentIndex: screenIndex,
        items: const [
          //Swipe Screen Icon
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 30,
            ),
            label: "",
          ),
          //View Screen Icon
          BottomNavigationBarItem(
            icon: Icon(
              Icons.remove_red_eye_outlined,
              size: 30,
            ),
            label: "",
          ),
          //Like Screen Icon
          BottomNavigationBarItem(
            icon: Icon(
              Icons.thumb_up_alt_outlined,
              size: 30,
            ),
            label: "",
          ),
          //Match Screen Icon
          BottomNavigationBarItem(
            icon: Icon(
              Icons.social_distance_outlined,
              size: 30,
            ),
            label: "",
          ),
          //User Details Screen Icon
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 30,
            ),
            label: "",
          ),
        ],
      ),
      body: tabScreenList[screenIndex],
    );
  }
}
