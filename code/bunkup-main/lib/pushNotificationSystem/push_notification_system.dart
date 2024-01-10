import 'package:bunkup/global.dart';
import 'package:bunkup/tabScreens/user_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PushNotificationSystem{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //Notification received
  Future whenNotificationReceived(BuildContext context) async{
    //When app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage)
    {
      if(remoteMessage != null){
        openAppShowNotificationData(
          remoteMessage.data["userID"],
          remoteMessage.data["senderID"],
          context,
        );
      }
    });

    //When app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage)
    {
      if(remoteMessage != null){
        openAppShowNotificationData(
          remoteMessage.data["userID"],
          remoteMessage.data["senderID"],
          context,
        );
      }
    });

    //When app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage)
    {
      if(remoteMessage != null){
        openAppShowNotificationData(
          remoteMessage.data["userID"],
          remoteMessage.data["senderID"],
          context,
        );
      }
    });
  }

  openAppShowNotificationData(receiverID, senderID, context) async{
    await FirebaseFirestore.instance
        .collection("users")
        .doc(senderID).get()
        .then((snapShot)
    {
      String profilePicture = snapShot.data()!["profilePicture"].toString();
      String firstName = snapShot.data()!["firstName"].toString();
      String lastName = snapShot.data()!["lastName"].toString();
      String batchYear = snapShot.data()!["batchYear"].toString();
      String municipality = snapShot.data()!["municipality"].toString();
      String cityOrProvince = snapShot.data()!["cityOrProvince"].toString();
      // String education = snapShot.data()!["education"].toString();
      // String gender = snapShot.data()!["gender"].toString();
      // String career = snapShot.data()!["career"].toString();
      // String interests = snapShot.data()!["interests"].toString();

      showDialog(
        context: context,
        builder: (context){
          return NotificationDialogBox(
            senderID,
            profilePicture,
            firstName,
            lastName,
            batchYear,
            municipality,
            cityOrProvince,
            context
          );
        }
      );
    });
  }

  NotificationDialogBox(senderID, profilePicture, firstName, lastName, batchYear, municipality, cityOrProvince, context){
    return Dialog(
      child: GridTile(
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: SizedBox(
            height: 300,
            child: Card(
              color: Colors.blue.shade200,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(profilePicture),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Name and Batch Year
                        Text(
                          firstName + " " + lastName + " ◉ " + batchYear.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8,),
                        //Location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 2,),
                            Expanded(
                              child: Text(
                                municipality + ", " + cityOrProvince.toString(),
                                maxLines: 4,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        //Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //View Profile
                            Center(
                              child: ElevatedButton(
                                onPressed: (){
                                  Get.back();
                                  Get.to(UserDetailsScreen(userID: senderID,));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text(
                                  "View Profile",
                                  style: TextStyle(
                                    color: Colors.white,

                                  ),
                                ),
                              ),
                            ),
                            //Cancel
                            Center(
                              child: ElevatedButton(
                                onPressed: (){
                                  Get.back();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  "Close",
                                  style: TextStyle(
                                    color: Colors.white,

                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future generateDeviceRegistrationToken() async{
    String? deviceToken = await messaging.getToken();

    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .update({
          "userDeviceToken": deviceToken,
        });
  }
}