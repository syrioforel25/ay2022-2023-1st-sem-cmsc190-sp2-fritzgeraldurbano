import 'package:bunkup/authenticationScreen/login_screen.dart';
import 'package:bunkup/editProfileScreen/edit_profile_screen.dart';
import 'package:bunkup/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserDetailsScreen extends StatefulWidget {
  String? userID;
  UserDetailsScreen({Key? key, this.userID}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  //User Info
  String firstName = '';
  String lastName = '';

  //Personal Info
  String batchYear = '';
  String gender = '';
  String phoneNumber = '';
  String minBudget = '';
  String maxBudget = '';
  String leaseDuration = '';
  String education = '';
  String degreeProgram = '';
  String municipality = '';
  String cityOrProvince = '';
  String profileHeading = '';

  //Lifestyle Preference
  String numberOfRoommates = '';
  String roommateGender = '';
  String cleanliness = '';
  String schedule = '';
  String sleepSchedule = '';
  String smoking = '';
  String drinking = '';
  String roommateInteraction = '';
  String guest = '';
  String pet = '';
  String cooking = '';
  String quiet = '';
  String interests = '';

  //Slider Images
  String profilePicture = 'https://firebasestorage.googleapis.com/v0/b/bunkup-5b2ac.appspot.com/o/Place%20Holder%2Fprofile_avatar.png?alt=media&token=26a9b7ba-9547-4ee5-b00b-6330fbe1697a';

  String reversePhoneNumberFormat(String formattedPhoneNumber) {
    // Check if the formattedPhoneNumber starts with '+63' and has a total length of 13
    if (formattedPhoneNumber.startsWith('+63') && formattedPhoneNumber.length == 13) {
      // Return the original number by removing the '+63' and concatenating '0' at the beginning
      return '0' + formattedPhoneNumber.substring(3);
    }
    // Return the original formatted number if it doesn't match the expected format
    return formattedPhoneNumber;
  }
  
  retrieveUserInfo() async {
    await FirebaseFirestore.instance.collection("users").doc(widget.userID).get().then((snapShot){
      if(snapShot.exists){
        setState(() {
          //User Info
          firstName = snapShot.data()!["firstName"];
          lastName = snapShot.data()!["lastName"];
          profilePicture = snapShot.data()!["profilePicture"];

          batchYear = snapShot.data()!["batchYear"].toString();
          gender = snapShot.data()!["gender"];
          phoneNumber = reversePhoneNumberFormat(snapShot.data()!["phoneNumber"]);
          minBudget = snapShot.data()!["minBudget"].toString();
          maxBudget = snapShot.data()!["maxBudget"].toString();
          leaseDuration = snapShot.data()!["leaseDuration"];
          education = snapShot.data()!["education"];
          degreeProgram = snapShot.data()!["degreeProgram"];
          municipality = snapShot.data()!["municipality"];
          cityOrProvince = snapShot.data()!["cityOrProvince"];
          profileHeading = snapShot.data()!["profileHeading"];

          //Lifestyle Preference
          numberOfRoommates = snapShot.data()!["numberOfRoommates"].toString();
          roommateGender = snapShot.data()!["roommateGender"];
          cleanliness = snapShot.data()!["cleanliness"];
          schedule = snapShot.data()!["schedule"];
          sleepSchedule = snapShot.data()!["sleepSchedule"];
          smoking = snapShot.data()!["smoking"];
          drinking = snapShot.data()!["drinking"];
          roommateInteraction = snapShot.data()!["roommateInteraction"];
          guest = snapShot.data()!["guest"];
          pet = snapShot.data()!["pet"];
          cooking = snapShot.data()!["cooking"];
          quiet = snapShot.data()!["quiet"];
          interests = snapShot.data()!["interests"];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(39, 66, 147, 1.0),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,

          ),
        ),
        centerTitle: true,
        //automaticallyImplyLeading: widget.userID == currentUserID ? false : true,
        leading: widget.userID != currentUserID ? IconButton(
          onPressed: (){
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_outlined, size: 30,),
        ) : Container(),
        actions: [
          widget.userID == currentUserID ?
          Row(
            children: [
              //Settings or Edit Profile
              IconButton(
                onPressed: (){
                  Get.to(EditProfileScreen());
                },
                icon: Icon(
                  Icons.edit_note_outlined,
                  size: 30,
                ),
              ),
              //Log out
              IconButton(
                onPressed: (){
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(
                  Icons.logout_outlined,
                  size: 30,
                ),
              ),
            ],
          ) : Container(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            //Image Slider
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Image.network(
                  profilePicture,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10,),
            //Personal Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                profileHeading,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 30,),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Personal Information",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              color: Colors.black54,
              thickness: 2,
            ),
            //Personal Info Table Data
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Table(
                children: [
                  //Name
                  TableRow(
                    children: [
                      const Text(
                        "Name: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        firstName + " " + lastName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Text(""),
                      Text(""),
                    ]
                  ),
                  //Gender
                  TableRow(
                    children: [
                      const Text(
                        "Gender: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        gender,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Budget
                  TableRow(
                    children: [
                      const Text(
                        "Budget: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        "₱ "+minBudget+" - "+maxBudget,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Lease Duration
                  TableRow(
                    children: [
                      const Text(
                        "Lease\nDuration: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        leaseDuration,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Education
                  TableRow(
                    children: [
                      const Text(
                        "Education: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        education,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Degree Program
                  TableRow(
                    children: [
                      const Text(
                        "Degree\nProgram: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        degreeProgram,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Batch Year
                  TableRow(
                    children: [
                      const Text(
                        "Batch Year: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        batchYear,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Municipality, City/Province
                  TableRow(
                    children: [
                      const Text(
                        "Municipality\n/City: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        municipality+", "+cityOrProvince,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Profile Heading
                  // TableRow(
                  //   children: [
                  //     const Text(
                  //       "Profile Heading: ",
                  //       style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 18,
                  //       ),
                  //     ),
                  //
                  //     Text(
                  //       profileHeading,
                  //       style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 18,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            //Personal Info
            const SizedBox(height: 30,),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Lifestyle Preference",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              color: Colors.black54,
              thickness: 2,
            ),
            //Personal Info Table Data
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Table(
                children: [
                  //Number of Roommates
                  TableRow(
                    children: [
                      const Text(
                        "Number of Roommates: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        numberOfRoommates,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Roommate Gender
                  TableRow(
                    children: [
                      const Text(
                        "Roommate\nGender: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        roommateGender,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Cleanliness
                  TableRow(
                    children: [
                      const Text(
                        "Cleanliness: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        cleanliness,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Schedule
                  TableRow(
                    children: [
                      const Text(
                        "Class/Work Schedule: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        schedule,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Sleep Schedule
                  TableRow(
                    children: [
                      const Text(
                        "Sleeping\nPattern: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        sleepSchedule,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Smoking
                  TableRow(
                    children: [
                      const Text(
                        "Smoking: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        smoking,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Drinking
                  TableRow(
                    children: [
                      const Text(
                        "Drinking: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        drinking,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Roommate Interaction
                  TableRow(
                    children: [
                      const Text(
                        "Roommate Interaction: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        roommateInteraction,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Guest
                  TableRow(
                    children: [
                      const Text(
                        "Guest/s: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        guest,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Pet
                  TableRow(
                    children: [
                      const Text(
                        "Pet/s: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        pet,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Cooking
                  TableRow(
                    children: [
                      const Text(
                        "Cooking: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        cooking,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Quiet
                  TableRow(
                    children: [
                      const Text(
                        "Noise\nPreference: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        quiet,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const TableRow(
                      children: [
                        Text(""),
                        Text(""),
                      ]
                  ),
                  //Interests
                  TableRow(
                    children: [
                      const Text(
                        "Interests: ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),

                      Text(
                        interests,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
