import 'dart:io';

import 'package:bunkup/global.dart';
import 'package:bunkup/tabScreens/user_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key}) : super(key: key);

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<String> likeSentList = [];
  List<String> likeReceivedList = [];
  List<String> commonList = [];
  List matchList = [];

  getLikeListKeys() async{
      var likeSentDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("likeSent").get();

      for(int i = 0; i < likeSentDocument.docs.length; i++){
        likeSentList.add(likeSentDocument.docs[i].id);
      }

      print("likeSentList = "+likeSentList.toString());

      var likeReceivedDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("likeReceived").get();

      for(int i = 0; i < likeReceivedDocument.docs.length; i++){
        likeReceivedList.add(likeReceivedDocument.docs[i].id);
      }

      commonList = likeSentList.where((key) => likeReceivedList.contains(key)).toList();
      print("likeReceived = "+likeReceivedList.toString());
      print("commonList = "+commonList.toString());
      getKeysDataFromUsersCollection(commonList);
  }

  getKeysDataFromUsersCollection(List<String> keysList) async{
    var allUsersDocument = await FirebaseFirestore.instance.collection("users").get();

    for(int i = 0; i < allUsersDocument.docs.length; i++){
      for(int j = 0; j < keysList.length; j++){
        if(((allUsersDocument.docs[i].data() as dynamic)["uid"]) == keysList[j]){
          matchList.add(allUsersDocument.docs[i].data());
        }
      }
    }

    setState(() {
      matchList;
    });
    print("matchList = "+matchList.toString());
  }

  chatViaWhatsApp(String receiverPhoneNumber) async{
    var androidUrl = "whatsapp://send?phone=$receiverPhoneNumber&text=Hi, I found your profile on BunkUP.";
    var iosUrl = "https://wa.me/$receiverPhoneNumber?text=${Uri.parse('Hi, I found your profile on BunkUP.')}";

    try{
      if(Platform.isIOS){
        await launchUrl((Uri.parse(iosUrl)));
      }else{
        await launchUrl((Uri.parse(androidUrl)));
      }
    }on Exception{
      showDialog(
          context: context,
          builder: (BuildContext context)
          {
            return AlertDialog(
              title: const Text("WhatsApp Not Installed"),
              content: const Text("Please install Whatsapp."),
              actions: [
                TextButton(
                  onPressed: ()
                  {
                    Get.back();
                  },
                  child: const Text("Ok"),
                ),
              ],
            );
          }
      );
    }
  }

  void _showDialog(BuildContext context, String phoneNumber, String uid) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Handle 'View Profile' button tap
                Navigator.of(context).pop(); // Close the dialog
                // Add your logic for 'View Profile' here
                Get.to(UserDetailsScreen(userID: uid.toString(),));
              },
              child: Text('View Profile'),
            ),
            TextButton(
              onPressed: () {
                // Handle 'Chat' button tap
                Navigator.of(context).pop(); // Close the dialog
                // Add your logic for 'Chat' here
                chatViaWhatsApp(phoneNumber.toString());
              },
              child: Text('Chat'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLikeListKeys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(39, 66, 147, 1.0),
        centerTitle: true,
        title: const Text(
          "My Matches",
          style: TextStyle(
            color: Colors.white,

          ),
        ),
      ),
      body: matchList.isEmpty
          ? const Center(
        child: Icon(Icons.person_off_sharp, color: Color.fromRGBO(39, 66, 147, 1.0), size: 60,),
      )
          : GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        children: List.generate(matchList.length, (index)
        {
          return GridTile(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Card(
                color: Colors.blue.shade200,
                child: GestureDetector(
                  onTap: (){
                    _showDialog(context,matchList[index]["phoneNumber"].toString(),matchList[index]["uid"].toString());
                    //chatViaWhatsApp(matchList[index]["phoneNumber"].toString());
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(matchList[index]["profilePicture"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(),
                            //Name and Batch Year
                            Text(
                              "${matchList[index]["firstName"]} ◉ ${matchList[index]["batchYear"]}",
                              maxLines: 2,
                              style: const TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4,),
                            //Municipality, City or Province
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                Expanded(
                                  child: Text(
                                    "${matchList[index]["municipality"]}, ${matchList[index]["cityOrProvince"]}",
                                    maxLines: 2,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: Colors.white,
                                      fontSize: 14,
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
          );
        }),
      ),
    );
  }
}
