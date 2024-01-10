import 'package:bunkup/global.dart';
import 'package:bunkup/tabScreens/user_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LikeScreen extends StatefulWidget {
  const LikeScreen({Key? key}) : super(key: key);

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  bool isLikeSentClicked = true;
  List<String> likeSentList = [];
  List<String> likeReceivedList = [];
  List likesList = [];

  getLikeListKeys() async{
    if(isLikeSentClicked){
      var likeSentDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("likeSent").get();

      for(int i = 0; i < likeSentDocument.docs.length; i++){
        likeSentList.add(likeSentDocument.docs[i].id);
      }
      print("likeSentList = "+likeSentList.toString());
      getKeysDataFromUsersCollection(likeSentList);
    }else{
      var likeReceivedDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("likeReceived").get();

      for(int i = 0; i < likeReceivedDocument.docs.length; i++){
        likeReceivedList.add(likeReceivedDocument.docs[i].id);
      }
      print("likeReceived = "+likeReceivedList.toString());
      getKeysDataFromUsersCollection(likeReceivedList);
    }
  }

  getKeysDataFromUsersCollection(List<String> keysList) async{
    var allUsersDocument = await FirebaseFirestore.instance.collection("users").get();

    for(int i = 0; i < allUsersDocument.docs.length; i++){
      for(int j = 0; j < keysList.length; j++){
        if(((allUsersDocument.docs[i].data() as dynamic)["uid"]) == keysList[j]){
          likesList.add(allUsersDocument.docs[i].data());
        }
      }
    }

    setState(() {
      likesList;
    });
    print("likesList = "+likesList.toString());
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: (){
                likeSentList.clear();
                likeSentList = [];
                likeReceivedList.clear();
                likeReceivedList = [];
                likesList.clear();
                likesList = [];

                setState(() {
                  isLikeSentClicked = true;
                });

                getLikeListKeys();
              },
              child: Text(
                "My Likes",
                style: TextStyle(
                  color: isLikeSentClicked ? Colors.white : Colors.grey,
                  fontWeight: isLikeSentClicked ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
            const Text(
              "   |   ",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: (){
                likeSentList.clear();
                likeSentList = [];
                likeReceivedList.clear();
                likeReceivedList = [];
                likesList.clear();
                likesList = [];

                setState(() {
                  isLikeSentClicked = false;
                });

                getLikeListKeys();
              },
              child: Text(
                "Likes Received",
                style: TextStyle(
                  color: isLikeSentClicked ? Colors.grey : Colors.white,
                  fontWeight: isLikeSentClicked ? FontWeight.normal : FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      body: likesList.isEmpty
          ? const Center(
        child: Icon(Icons.person_off_sharp, color: Color.fromRGBO(39, 66, 147, 1.0), size: 60,),
      )
          : GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        children: List.generate(likesList.length, (index)
        {
          return GridTile(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Card(
                color: Colors.blue.shade200,
                child: GestureDetector(
                  onTap: (){
                    Get.to(UserDetailsScreen(userID: likesList[index]["uid"].toString(),));
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(likesList[index]["profilePicture"]),
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
                              "${likesList[index]["firstName"]} ◉ ${likesList[index]["batchYear"]}",
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
                                    "${likesList[index]["municipality"]}, ${likesList[index]["cityOrProvince"]}",
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
