import 'dart:io';

import 'package:bunkup/controllers/profile_controller.dart';
import 'package:bunkup/global.dart';
import 'package:bunkup/tabScreens/user_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/custom_text_field_widget.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/ranged_text_field_widget.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({Key? key}) : super(key: key);

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  ProfileController profileController = Get.put(ProfileController());
  String senderName = "";

  TextEditingController batchYearTextEditingController = TextEditingController();
  TextEditingController budgetTextEditingController = TextEditingController();
  TextEditingController numberOfRoommatesTextEditingController = TextEditingController();

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            title: const Text("Suggested Roommate Info"),
            content: const Text("The list of suggested roommates are ranked from the most to least compatible based on the preferences you provided."),
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

  applyFilter(){
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState)
          {
            return AlertDialog(
              backgroundColor: Color.fromRGBO(245,246,249, 1.0),
              title: const Text(
                "Roommate Filter",
                style: TextStyle(color: Colors.black54),
              ),
              //Filters
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Batch Year
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomTextFieldWidget(
                        editingController: batchYearTextEditingController,
                        labelText: "Batch Year",
                        iconData: Icons.school_outlined,
                        isObscure: false,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Gender
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomDropdownWidget(
                        selectedValue: filterGender,
                        items: ['Male', 'Female', 'Non-Binary'],
                        onChanged: (String? newValue) {
                          setState(() {
                            filterGender = newValue; // Update the selected value in the parent widget's state
                          });
                        },
                        labelText: 'Gender',
                        iconData: Icons.people_outline,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Lease Duration
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomDropdownWidget(
                        selectedValue: filterLeaseDuration,
                        items: ['Month-to-Month', '3 Months', '6 Months', '1 Year'],
                        onChanged: (String? newValue) {
                          setState(() {
                            filterLeaseDuration = newValue; // Update the selected value in the parent widget's state
                          });
                        },
                        labelText: 'Lease Duration',
                        iconData: Icons.access_time_outlined,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Number of Roommates
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomTextFieldWidget(
                        editingController: numberOfRoommatesTextEditingController,
                        labelText: "Number of Roommates",
                        iconData: Icons.people_outline,
                        isObscure: false,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Cleanliness
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomDropdownWidget(
                        selectedValue: filterCleanliness,
                        items: ['Very Clean', 'Clean', 'Moderate', 'Messy', 'Very Messy'],
                        onChanged: (String? newValue) {
                          setState(() {
                            filterCleanliness = newValue; // Update the selected value in the parent widget's state
                          });
                        },
                        labelText: 'Cleanliness',
                        iconData: Icons.cleaning_services,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Schedule
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomDropdownWidget(
                        selectedValue: filterSchedule,
                        items: ['Regular 9-5', 'Flexible Hours', 'Part-Time', 'Shift Work', 'Remote/Freelance'],
                        onChanged: (String? newValue) {
                          setState(() {
                            filterSchedule = newValue; // Update the selected value in the parent widget's state
                          });
                        },
                        labelText: 'Work/Class Schedule',
                        iconData: Icons.schedule_outlined,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Sleep Schedule
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomDropdownWidget(
                        selectedValue: filterSleepSchedule,
                        items: ['Early Riser',
                          'Night Owl',
                          'Regular Sleeper',
                          'Light Sleeper',
                          'Irregular Sleeper'],
                        onChanged: (String? newValue) {
                          setState(() {
                            filterSleepSchedule = newValue; // Update the selected value in the parent widget's state
                          });
                        },
                        labelText: 'Sleeping Schedule/Pattern.',
                        iconData: Icons.bed_outlined,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Smoking
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomDropdownWidget(
                        selectedValue: filterSmoking,
                        items: ['Yes', 'No'],
                        onChanged: (String? newValue) {
                          setState(() {
                            filterSmoking = newValue; // Update the selected value in the parent widget's state
                          });
                        },
                        labelText: 'Smoking',
                        iconData: Icons.smoke_free_outlined,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Drinking
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomDropdownWidget(
                        selectedValue: filterDrinking,
                        items: ['Yes', 'No'],
                        onChanged: (String? newValue) {
                          setState(() {
                            filterDrinking = newValue; // Update the selected value in the parent widget's state
                          });
                        },
                        labelText: 'Drinking',
                        iconData: Icons.local_drink_outlined,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Roommate Interaction
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomDropdownWidget(
                        selectedValue: filterRoommateInteraction,
                        items: [
                          'Very Friendly',
                          'Friendly',
                          'Neutral',
                          'Reserved',
                          'Very Reserved',
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            filterRoommateInteraction = newValue; // Update the selected value in the parent widget's state
                          });
                        },
                        labelText: 'Roommate Interaction',
                        iconData: Icons.social_distance_outlined,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Guest
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomDropdownWidget(
                        selectedValue: filterGuest,
                        items: ['Yes', 'No'],
                        onChanged: (String? newValue) {
                          setState(() {
                            filterGuest = newValue; // Update the selected value in the parent widget's state
                          });
                        },
                        labelText: 'Guest/s',
                        iconData: Icons.people_outline,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Pet
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomDropdownWidget(
                        selectedValue: filterPet,
                        items: ['Yes', 'No'],
                        onChanged: (String? newValue) {
                          setState(() {
                            filterPet = newValue; // Update the selected value in the parent widget's state
                          });
                        },
                        labelText: 'Pet/s',
                        iconData: Icons.pets_outlined,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Cooking
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomDropdownWidget(
                        selectedValue: filterCooking,
                        items: ['Everyday', 'Several times a week', 'Once or twice a week', 'Rarely', 'Never'],
                        onChanged: (String? newValue) {
                          setState(() {
                            filterCooking = newValue; // Update the selected value in the parent widget's state
                          });
                        },
                        labelText: 'Cooking',
                        iconData: Icons.kitchen_outlined,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    //Quiet
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 36,
                      height: 55,
                      child: CustomDropdownWidget(
                        selectedValue: filterQuiet,
                        items: ['Very Quiet', 'Quiet', 'Moderate', 'Noisy', 'Very Noisy'],
                        onChanged: (String? newValue) {
                          setState(() {
                            filterQuiet = newValue; // Update the selected value in the parent widget's state
                          });
                        },
                        labelText: 'Noise Level Preference.',
                        iconData: Icons.noise_aware_outlined,
                      ),
                    ),
                  ],
                ),
              ),
              //Buttons
              actions: [
                ElevatedButton(
                  onPressed: (){
                    filterBatchYear = null;
                    filterGender = null;
                    filterLeaseDuration = null;
                    filterNumberOfRoommates = null;
                    filterCleanliness = null;
                    filterSchedule = null;
                    filterSleepSchedule = null;
                    filterSmoking = null;
                    filterDrinking = null;
                    filterRoommateInteraction = null;
                    filterGuest = null;
                    filterPet = null;
                    filterCooking = null;
                    filterQuiet = null;
                    batchYearTextEditingController.clear();
                    numberOfRoommatesTextEditingController.clear();
                    Get.back();
                    profileController.getFilterResults();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(39, 66, 147, 1.0),
                  ),
                  child: const Text(
                    "Clear Filter",
                  ),
                ),
                ElevatedButton(
                  onPressed: (){
                    filterBatchYear = batchYearTextEditingController.text.trim();
                    filterNumberOfRoommates = numberOfRoommatesTextEditingController.text.trim();
                    //Allows user to close the empty filter
                    if(filterBatchYear == null && filterGender == null && filterLeaseDuration == null
                        && filterNumberOfRoommates == null && filterCleanliness == null && filterSchedule == null
                        && filterSleepSchedule == null && filterSmoking == null && filterDrinking == null && filterRoommateInteraction == null
                        && filterGuest == null && filterPet == null && filterCooking == null && filterQuiet == null){
                      Get.back();
                      profileController.getFilterResults();
                    }
                    //Allows to the user to submit the filter only if it complete
                    else if(filterBatchYear != null && filterGender != null && filterLeaseDuration != null
                        && filterNumberOfRoommates != null && filterCleanliness != null && filterSchedule != null
                        && filterSleepSchedule != null && filterSmoking != null && filterDrinking != null && filterRoommateInteraction != null
                        && filterGuest != null && filterPet != null && filterCooking != null && filterQuiet != null)
                    {
                      Get.back();
                      profileController.getFilterResults();
                    //Shows a snackbar if a certain filter field is empty
                    }else{
                      Get.snackbar("Incomplete Filters",
                          "Please fill out all the filter fields to apply the filters.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(39, 66, 147, 1.0),
                  ),
                  child: const Text(
                    "Done",
                  ),
                ),
              ],

            );
          },
        );
      },
    );
  }

  readCurrentUserData() async{
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .get()
        .then((dataSnapshot)
    {
      setState(() {
        senderName = "${dataSnapshot.data()!["firstName"].toString()} ${dataSnapshot.data()!["lastName"].toString()}";
      });
    });
  }

  void firstTimeUserPrompt() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Welcome to BunkUP! Here's a quick start guide."),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Swipe Screen:"),
              Text("- Swipe through potential roommates ranked from most to least compatible."),
              Text("- Like a profile by tapping the like button."),
              Text("- View a profile by tapping the profile button."),
              const SizedBox(height: 5),
              Text("Views Screen:"),
              Text("- Visited Profiles: Check out profiles you've visited."),
              Text("- Profile Visitors: See who's checked out your profile."),
              Text("- Click on a user to view their profile in detail."),
              const SizedBox(height: 5),
              Text("Likes Screen:"),
              Text("- My Likes: Profiles you've liked."),
              Text("- Likes Received: Users who liked your profile."),
              Text("- Click on a user to view their profile in detail."),
              const SizedBox(height: 5),
              Text("Matches Screen:"),
              Text("- Discover mutual likes – where you and another user both liked each other."),
              Text("- Click on a match to view their profile or initiate a chat via WhatsApp."),
              const SizedBox(height: 5),
              Text("User Profile Screen:"),
              Text("- View and edit your own profile."),
              Text("- Ensure your profile reflects your personality and preferences accurately."),
              const SizedBox(height: 10),
            ],
          ),
          actions: [ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Got It"),
          ),],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCurrentUserData();
    if(isNewUser == true){
      Future.delayed(Duration.zero, () => firstTimeUserPrompt());
    }
    //Future.delayed(Duration.zero, () => firstTimeUserPrompt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(39, 66, 147, 1.0),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (){
              _showDialog();
            },
            icon: const Icon(Icons.info_outline, size: 30,),
          ),
        ],
        title: const Text(
          "Find Roommates",
          style: TextStyle(
            color: Colors.white,

          ),
        ),
      ),
      body: Obx(()
      {
        return PageView.builder(
          itemCount: profileController.allUsersProfileList.length,
          controller: PageController(
            initialPage: 0,
            viewportFraction: 1,
          ),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            final eachProfileInfo = profileController.allUsersProfileList[index];
            return DecoratedBox(
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      eachProfileInfo.profilePicture.toString(),
                    ),
                    fit: BoxFit.cover,
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    //Filter button
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(top: 8),
                    //     child: IconButton(
                    //       onPressed: (){
                    //         applyFilter();
                    //       },
                    //       icon: const Icon(
                    //         Icons.filter_list_outlined,
                    //         size: 30,
                    //         color: Color.fromRGBO(39, 66, 147, 1.0),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (){
                        // profileController.viewFunction(eachProfileInfo.uid.toString(), senderName);
                        // //Send user to the profile details of the selected profile
                        // Get.to(UserDetailsScreen(userID: eachProfileInfo.uid.toString(),));
                      },
                      child: Column(
                        children: [
                          //Full name
                          Text(
                            eachProfileInfo.firstName.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          //Batch,Municipality and City
                          // Text(
                          //   "Batch "+eachProfileInfo.batchYear.toString() + " ⦿ " + eachProfileInfo.cityOrProvince.toString(),
                          //   style: const TextStyle(
                          //     color: Colors.white,
                          //     fontSize: 24,
                          //     letterSpacing: 4,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          const SizedBox(height: 4,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Batch
                              ElevatedButton(
                                onPressed: (){},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white30,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)
                                  ),
                                ),
                                child: Text(
                                  "Batch "+eachProfileInfo.batchYear.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6,),
                              //City or Municipality
                              ElevatedButton(
                                onPressed: (){},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white30,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)
                                  ),
                                ),
                                child: Text(
                                  eachProfileInfo.cityOrProvince.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //School or University
                              // ElevatedButton(
                              //   onPressed: (){},
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: Colors.white30,
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(16)
                              //     ),
                              //   ),
                              //   child: Text(
                              //     eachProfileInfo.education.toString(),
                              //     style: const TextStyle(
                              //       color: Colors.white,
                              //       fontSize: 14,
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(width: 6,),
                              //Degree Program
                              ElevatedButton(
                                onPressed: (){},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white30,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)
                                  ),
                                ),
                                child: Text(
                                  eachProfileInfo.degreeProgram.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     //Gender
                          //     ElevatedButton(
                          //       onPressed: (){},
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor: Colors.white30,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(16)
                          //         ),
                          //       ),
                          //       child: Text(
                          //         eachProfileInfo.gender.toString(),
                          //         style: const TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 14,
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 6,),
                          //     //Interests
                          //     ElevatedButton(
                          //       onPressed: (){},
                          //       style: ElevatedButton.styleFrom(
                          //         backgroundColor: Colors.white30,
                          //         shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(16)
                          //         ),
                          //       ),
                          //       child: Text(
                          //         eachProfileInfo.interests.toString(),
                          //         style: const TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 14,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14,),
                    //Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Profile
                        ElevatedButton(
                          onPressed: ()
                          {
                            profileController.viewFunction(eachProfileInfo.uid.toString(), senderName);
                            //Send user to the profile details of the selected profile
                            Get.to(UserDetailsScreen(userID: eachProfileInfo.uid.toString(),));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: CircleBorder(),
                          ),
                          child: Image.asset(
                            "images/profile.png",
                            width: 60,
                          ),
                        ),
                        //Like
                        ElevatedButton(
                          onPressed: ()
                          {
                            profileController.like(eachProfileInfo.uid.toString(), senderName);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shape: CircleBorder(),
                          ),
                          child: Image.asset(
                                "images/like.png",
                                width: 60,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
