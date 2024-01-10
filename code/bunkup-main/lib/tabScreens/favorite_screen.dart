import 'package:bunkup/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool isFavoriteSentClicked = true;
  List<String> favoriteSentList = [];
  List<String> favoriteReceivedList = [];
  List favoritesList = [];

  getFavoriteListKeys() async{
    if(isFavoriteSentClicked){
      var favoriteSentDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("favoriteSent").get();

      for(int i = 0; i < favoriteSentDocument.docs.length; i++){
        favoriteSentList.add(favoriteSentDocument.docs[i].id);
      }
      print("favoriteSentList = "+favoriteSentList.toString());
      getKeysDataFromUsersCollection(favoriteSentList);
    }else{
      var favoriteReceivedDocument = await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserID).collection("favoriteReceived").get();

      for(int i = 0; i < favoriteReceivedDocument.docs.length; i++){
        favoriteReceivedList.add(favoriteReceivedDocument.docs[i].id);
      }
      print("favoriteReceived = "+favoriteReceivedList.toString());
      getKeysDataFromUsersCollection(favoriteReceivedList);
    }
  }

  getKeysDataFromUsersCollection(List<String> keysList) async{
    var allUsersDocument = await FirebaseFirestore.instance.collection("users").get();

    for(int i = 0; i < allUsersDocument.docs.length; i++){
      for(int j = 0; j < keysList.length; j++){
        if(((allUsersDocument.docs[i].data() as dynamic)["uid"]) == keysList[j]){
          favoritesList.add(allUsersDocument.docs[i].data());
        }
      }
    }

    setState(() {
      favoritesList;
    });
    print("favoritesList = "+favoritesList.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavoriteListKeys();
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
                favoriteSentList.clear();
                favoriteSentList = [];
                favoriteReceivedList.clear();
                favoriteReceivedList = [];
                favoritesList.clear();
                favoritesList = [];

                setState(() {
                  isFavoriteSentClicked = true;
                });

                getFavoriteListKeys();
              },
              child: Text(
                "My Favorites",
                style: TextStyle(
                  color: isFavoriteSentClicked ? Colors.white : Colors.grey,
                  fontWeight: isFavoriteSentClicked ? FontWeight.bold : FontWeight.normal,
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
                favoriteSentList.clear();
                favoriteSentList = [];
                favoriteReceivedList.clear();
                favoriteReceivedList = [];
                favoritesList.clear();
                favoritesList = [];

                setState(() {
                  isFavoriteSentClicked = false;
                });

                getFavoriteListKeys();
              },
              child: Text(
                "Favorites Received",
                style: TextStyle(
                  color: isFavoriteSentClicked ? Colors.grey : Colors.white,
                  fontWeight: isFavoriteSentClicked ? FontWeight.normal : FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      body: favoritesList.isEmpty
          ? const Center(
              child: Icon(Icons.person_off_sharp, color: Color.fromRGBO(39, 66, 147, 1.0), size: 60,),
            )
          : GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8),
              children: List.generate(favoritesList.length, (index)
              {
                return GridTile(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Card(
                      color: Colors.blue.shade200,
                      child: GestureDetector(
                        onTap: (){

                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(favoritesList[index]["profilePicture"]),
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
                                  //Name and Age
                                  Text(
                                    "${favoritesList[index]["firstName"]} ${favoritesList[index]["lastName"]} ◉ ${favoritesList[index]["age"]}",
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
                                        color: Colors.grey,
                                        size: 16,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${favoritesList[index]["municipality"]}, ${favoritesList[index]["cityOrProvince"]}",
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
