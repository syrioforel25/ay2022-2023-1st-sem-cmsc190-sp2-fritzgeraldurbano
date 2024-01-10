import 'package:bunkup/global.dart';
import 'package:bunkup/tabScreens/user_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  bool isViewSentClicked = true;
  List<String> viewSentList = [];
  List<String> viewReceivedList = [];
  List viewsList = [];

  getViewListKeys() async{
    if(isViewSentClicked){
      var viewSentDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("viewSent").get();

      for(int i = 0; i < viewSentDocument.docs.length; i++){
        viewSentList.add(viewSentDocument.docs[i].id);
      }
      print("viewSentList = "+viewSentList.toString());
      getKeysDataFromUsersCollection(viewSentList);
    }else{
      var viewReceivedDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("viewReceived").get();

      for(int i = 0; i < viewReceivedDocument.docs.length; i++){
        viewReceivedList.add(viewReceivedDocument.docs[i].id);
      }
      print("viewReceived = "+viewReceivedList.toString());
      getKeysDataFromUsersCollection(viewReceivedList);
    }
  }

  getKeysDataFromUsersCollection(List<String> keysList) async{
    var allUsersDocument = await FirebaseFirestore.instance.collection("users").get();

    for(int i = 0; i < allUsersDocument.docs.length; i++){
      for(int j = 0; j < keysList.length; j++){
        if(((allUsersDocument.docs[i].data() as dynamic)["uid"]) == keysList[j]){
          viewsList.add(allUsersDocument.docs[i].data());
        }
      }
    }

    setState(() {
      viewsList;
    });
    print("viewsList = "+viewsList.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getViewListKeys();
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
                viewSentList.clear();
                viewSentList = [];
                viewReceivedList.clear();
                viewReceivedList = [];
                viewsList.clear();
                viewsList = [];

                setState(() {
                  isViewSentClicked = true;
                });

                getViewListKeys();
              },
              child: Text(
                "Visited Profiles",
                style: TextStyle(
                  color: isViewSentClicked ? Colors.white : Colors.grey,
                  fontWeight: isViewSentClicked ? FontWeight.bold : FontWeight.normal,
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
                viewSentList.clear();
                viewSentList = [];
                viewReceivedList.clear();
                viewReceivedList = [];
                viewsList.clear();
                viewsList = [];

                setState(() {
                  isViewSentClicked = false;
                });

                getViewListKeys();
              },
              child: Text(
                "Profile Visitors",
                style: TextStyle(
                  color: isViewSentClicked ? Colors.grey : Colors.white,
                  fontWeight: isViewSentClicked ? FontWeight.normal : FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      body: viewsList.isEmpty
          ? const Center(
        child: Icon(Icons.person_off_sharp, color: Color.fromRGBO(39, 66, 147, 1.0), size: 60,),
      )
          : GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        children: List.generate(viewsList.length, (index)
        {
          return GridTile(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Card(
                color: Colors.blue.shade200,
                child: GestureDetector(
                  onTap: (){
                    Get.to(UserDetailsScreen(userID: viewsList[index]["uid"].toString(),));
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(viewsList[index]["profilePicture"]),
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
                              "${viewsList[index]["firstName"]} ◉ ${viewsList[index]["batchYear"]}",
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
                                    "${viewsList[index]["municipality"]}, ${viewsList[index]["cityOrProvince"]}",
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
