import 'dart:convert';

import 'package:bunkup/global.dart';
import 'package:bunkup/models/person.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController{
  final Rx<List<Person>> usersProfileList = Rx<List<Person>>([]);
  List<Person> get allUsersProfileList => usersProfileList.value;

  readCurrentUserData() async{
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .get()
        .then((dataSnapshot)
    {
      filterBatchYear = dataSnapshot.data()!["batchYear"].toString();
      filterGender = dataSnapshot.data()!["roommateGender"].toString();
      filterLeaseDuration = dataSnapshot.data()!["leaseDuration"].toString();
      filterNumberOfRoommates = dataSnapshot.data()!["numberOfRoommates"].toString();
      filterCleanliness = dataSnapshot.data()!["cleanliness"].toString();
      filterSchedule = dataSnapshot.data()!["schedule"].toString();
      filterSleepSchedule = dataSnapshot.data()!["sleepSchedule"].toString();
      filterSmoking = dataSnapshot.data()!["smoking"].toString();
      filterDrinking = dataSnapshot.data()!["drinking"].toString();
      filterRoommateInteraction = dataSnapshot.data()!["roommateInteraction"].toString();
      filterGuest = dataSnapshot.data()!["guest"].toString();
      filterPet = dataSnapshot.data()!["pet"].toString();
      filterCooking = dataSnapshot.data()!["cooking"].toString();
      filterQuiet = dataSnapshot.data()!["quiet"].toString();
      filterMaxBudget = dataSnapshot.data()!["maxBudget"].toString();
      filterMinBudget = dataSnapshot.data()!["minBudget"].toString();
    });
  }

  getFilterResults(){
    onInit();
  }

  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    //Bug here when a new register it is stucked here in readCurrentUserData
    if(isNewUser == false){
      print("Old user here");
      await readCurrentUserData();
    }else{
      print("New user here");
    }
    usersProfileList.bindStream(
        FirebaseFirestore.instance
            .collection("users")
            .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots()
            .map((QuerySnapshot queryDataSnapshot)
        {
          List<Person> profilesList = [];

          for(var eachProfile in queryDataSnapshot.docs){
            Person profile = Person.fromDataSnapshot(eachProfile);
            int matchCount = 0;

            if (profile.batchYear == filterBatchYear.toString()) {
              matchCount++;
            }
            if (profile.roommateGender == filterGender.toString()) {
              matchCount++;
            }
            if (profile.leaseDuration == filterLeaseDuration.toString()) {
              matchCount++;
            }
            if (profile.numberOfRoommates == int.parse(filterNumberOfRoommates.toString())) {
              matchCount++;
            }
            if (profile.cleanliness == filterCleanliness.toString()) {
              matchCount++;
            }
            if (profile.schedule == filterSchedule.toString()) {
              matchCount++;
            }
            if (profile.sleepSchedule == filterSleepSchedule.toString()) {
              matchCount++;
            }
            if (profile.smoking == filterSmoking.toString()) {
              matchCount++;
            }
            if (profile.drinking == filterDrinking.toString()) {
              matchCount++;
            }
            if (profile.roommateInteraction == filterRoommateInteraction.toString()) {
              matchCount++;
            }
            if (profile.guest == filterGuest.toString()) {
              matchCount++;
            }
            if (profile.pet == filterPet.toString()) {
              matchCount++;
            }
            if (profile.cooking == filterCooking.toString()) {
              matchCount++;
            }
            if (profile.quiet == filterQuiet.toString()) {
              matchCount++;
            }
            if((double.parse(filterMaxBudget.toString()) >= profile.minBudget! && double.parse(filterMinBudget.toString()) <= profile.maxBudget!)
                || (profile.maxBudget! >= double.parse(filterMinBudget.toString()) && profile.minBudget! <= double.parse(filterMaxBudget.toString()))){
              matchCount++;
            }
            print(profile.firstName!+": "+matchCount.toString());
            profile.matchCount = matchCount;
            profilesList.add(profile);
          }
          profilesList.sort((a, b) => (b.matchCount ?? 0).compareTo(a.matchCount ?? 0));
          return profilesList;
        })
    );
    // //No filter applied
    // if(filterBatchYear == null || filterGender == null || filterLeaseDuration == null
    //     || filterNumberOfRoommates == null || filterCleanliness == null || filterSchedule == null
    //     || filterSleepSchedule == null || filterSmoking == null || filterDrinking == null || filterRoommateInteraction == null
    //     || filterGuest == null || filterPet == null || filterCooking == null || filterQuiet == null){
    //
    //   usersProfileList.bindStream(
    //       FirebaseFirestore.instance
    //           .collection("users")
    //           .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //           .snapshots()
    //           .map((QuerySnapshot queryDataSnapshot)
    //       {
    //         List<Person> profilesList = [];
    //
    //         for(var eachProfile in queryDataSnapshot.docs){
    //           profilesList.add(Person.fromDataSnapshot(eachProfile));
    //         }
    //
    //         return profilesList;
    //       })
    //   );
    // //Filters applied
    // }else{
    //   usersProfileList.bindStream(
    //       FirebaseFirestore.instance
    //           .collection("users")
    //           .where("gender", isEqualTo: filterGender.toString())
    //           .where("batchYear", isEqualTo: filterBatchYear.toString())
    //           .where("leaseDuration", isEqualTo: filterLeaseDuration.toString())
    //           .where("numberOfRoommates", isEqualTo: int.parse(filterNumberOfRoommates.toString()))
    //           .where("cleanliness", isEqualTo: filterCleanliness.toString())
    //           .where("schedule", isEqualTo: filterSchedule.toString())
    //           .where("sleepSchedule", isEqualTo: filterSleepSchedule.toString())
    //           .where("smoking", isEqualTo: filterSmoking.toString())
    //           .where("drinking", isEqualTo: filterDrinking.toString())
    //           .where("roommateInteraction", isEqualTo: filterRoommateInteraction.toString())
    //           .where("guest", isEqualTo: filterGuest.toString())
    //           .where("pet", isEqualTo: filterPet.toString())
    //           .where("cooking", isEqualTo: filterCooking.toString())
    //           .where("quiet", isEqualTo: filterQuiet.toString())
    //           .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //           .snapshots()
    //           .map((QuerySnapshot queryDataSnapshot)
    //       {
    //         List<Person> profilesList = [];
    //
    //         for(var eachProfile in queryDataSnapshot.docs){
    //           profilesList.add(Person.fromDataSnapshot(eachProfile));
    //         }
    //
    //         if(profilesList.isEmpty){
    //           usersProfileList.bindStream(
    //               FirebaseFirestore.instance
    //                   .collection("users")
    //                   .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //                   .snapshots()
    //                   .map((QuerySnapshot queryDataSnapshot)
    //               {
    //                 List<Person> profilesList = [];
    //
    //                 for(var eachProfile in queryDataSnapshot.docs){
    //                   profilesList.add(Person.fromDataSnapshot(eachProfile));
    //                 }
    //
    //                 return profilesList;
    //               })
    //           );
    //           Get.snackbar("No Matches Found", "Sorry, no matches found with the selected filters. Please try adjusting your preferences for better results.");
    //         }else{
    //           Get.snackbar("Filters Applied", "Filters are now applied. Enjoy swiping!");
    //         }
    //         return profilesList;
    //       })
    //   );
    // }
  }

  favorite(String toUserID, String sender) async {
    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(toUserID).collection("favoriteReceived").doc(currentUserID)
        .get();

    //Remove favorite if it exist
    if(document.exists){
      //Remove currentUser from the favorite received list of the receiver
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID).collection("favoriteReceived").doc(currentUserID)
          .delete();

      //Remove toUser from the favorite received list of the currentUser
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("favoriteSent").doc(toUserID)
          .delete();
    //Mark as favorite if it does not exist
    }else{
      //Add currentUser from the favorite received list of the receiver
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID).collection("favoriteReceived").doc(currentUserID)
          .set({});

      //Add toUser from the favorite received list of the currentUser
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("favoriteSent").doc(toUserID)
          .set({});

      //Send notification
      sendNotificationToUser(toUserID, "favorite", sender);
    }
    update();
  }

  like(String toUserID, String sender) async {
    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(toUserID).collection("likeReceived").doc(currentUserID)
        .get();

    //Remove like if it exist
    if(document.exists){
      Get.snackbar("Unliked Profile","You unliked this profile.");
      //Remove currentUser from the like received list of the receiver
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID).collection("likeReceived").doc(currentUserID)
          .delete();

      //Remove toUser from the like received list of the currentUser
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("likeSent").doc(toUserID)
          .delete();

      sendNotificationToUser(toUserID, "like", sender);
      //Mark as like if it does not exist
    }else{
      Get.snackbar("Liked Profile","You liked this profile!");
      //Add currentUser from the like received list of the receiver
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID).collection("likeReceived").doc(currentUserID)
          .set({});

      //Add toUser from the like received list of the currentUser
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("likeSent").doc(toUserID)
          .set({});
      //sendNotificationToUser(toUserID, "unliked", sender);

      //Send notification

    }
    update();
  }

  viewFunction(String toUserID, String sender) async {
    var document = await FirebaseFirestore.instance
        .collection("users")
        .doc(toUserID).collection("viewReceived").doc(currentUserID)
        .get();

    //Remove like if it exist
    if(document.exists){
      print("Already in views list");
      //Mark as viewed if it does not exist
    }else{
      //Add currentUser from the views received list of the receiver
      await FirebaseFirestore.instance
          .collection("users")
          .doc(toUserID).collection("viewReceived").doc(currentUserID)
          .set({});

      //Add toUser from the views received list of the currentUser
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("viewSent").doc(toUserID)
          .set({});

      //Send notification
      sendNotificationToUser(toUserID, "view", sender);
    }
    update();
  }

  sendNotificationToUser(receiverID, featureType, senderName) async{
    String userDeviceToken = "";

    await FirebaseFirestore.instance
        .collection("users")
        .doc(receiverID).get()
        .then((snapShot)
    {
      if(snapShot.data()!["userDeviceToken"] != null){
        userDeviceToken = snapShot.data()!["userDeviceToken"].toString();
      }
    });

    notificationFormat(
      userDeviceToken,
      receiverID,
      featureType,
      senderName
    );
  }

  notificationFormat(userDeviceToken, receiverID, featureType, senderName){
    Map<String, String> headerNotification = {
      "Content-type": "application/json",
      "Authorization": fcmServerToken,

    };

    Map bodyNotification =
    {
      "body": "$senderName $featureType"+"ed your profile. Click to see.",
      "title": "New $featureType",
    };

    Map dataMap =
    {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "userID": receiverID,
      "senderID": currentUserID,
    };

    Map notificationOfficialFormat =
    {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": userDeviceToken,
    };

    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(notificationOfficialFormat),
    );
  }
}