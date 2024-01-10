import 'dart:io';

import 'package:bunkup/global.dart';
import 'package:bunkup/homeScreen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../tabScreens/user_details_screen.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/dropdown_widget.dart';
import '../widgets/ranged_text_field_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool uploading = false;

  //User Info
  TextEditingController firstNameTextEditingController = TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();

  //Personal Info
  TextEditingController batchYearTextEditingController = TextEditingController();
  String? gender;
  TextEditingController phoneNumberTextEditingController = TextEditingController();
  TextEditingController budgetMinController = TextEditingController();
  TextEditingController budgetMaxController = TextEditingController();
  RangeValues? budgetRange;
  String? leaseDuration;
  TextEditingController educationTextEditingController = TextEditingController();
  TextEditingController degreeProgramTextEditingController = TextEditingController();
  TextEditingController municipalityTextEditingController = TextEditingController();
  TextEditingController cityOrProvinceTextEditingController = TextEditingController();
  TextEditingController profileHeadingTextEditingController = TextEditingController();

  //Lifestyle Preference
  TextEditingController numberOfRoommatesTextEditingController = TextEditingController();
  String? roommateGender;
  String? cleanliness;
  String? schedule;
  String? sleepSchedule;
  String? smoking;
  String? drinking;
  String? roommateInteraction;
  String? guest;
  String? pet;
  String? cooking;
  String? quiet;
  TextEditingController interestsTextEditingController = TextEditingController();

  //String? imageChecker;

  //User Info
  String firstName = '';
  String lastName = '';

  //Personal Info
  String batchYear = '';
  String genderValue = '';
  String phoneNumber = '';
  String minBudget = '';
  String maxBudget = '';
  String leaseDurationValue = '';
  String education = '';
  String degreeProgram = '';
  String municipality = '';
  String cityOrProvince = '';
  String profileHeading = '';

  //Lifestyle Preference
  String numberOfRoommates = '';
  String roommateGenderValue = '';
  String cleanlinessValue = '';
  String scheduleValue = '';
  String sleepScheduleValue = '';
  String smokingValue = '';
  String drinkingValue = '';
  String roommateInteractionValue = '';
  String guestValue = '';
  String petValue = '';
  String cookingValue = '';
  String quietValue = '';
  String interests = '';
  String userImage = '';

  late Rx<File?> pickedFile;
  File? get profilePicture => pickedFile.value;
  XFile? imageFile;

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0') && phoneNumber.length == 11) {
      return '+63' + phoneNumber.substring(1);
    }
    // Return the original number if it doesn't match the expected format
    return phoneNumber;
  }

  String reversePhoneNumberFormat(String formattedPhoneNumber) {
    // Check if the formattedPhoneNumber starts with '+63' and has a total length of 13
    if (formattedPhoneNumber.startsWith('+63') && formattedPhoneNumber.length == 13) {
      // Return the original number by removing the '+63' and concatenating '0' at the beginning
      return '0' + formattedPhoneNumber.substring(3);
    }
    // Return the original formatted number if it doesn't match the expected format
    return formattedPhoneNumber;
  }

  bool isValidPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^(0|\+63)9\d{9}$');
    return regex.hasMatch(phoneNumber);
  }

  pickImageFileFromGallery() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      Get.snackbar("Profile Picture",
          "You have successfully selected your profile picture.");
    }

    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  captureImageFromPhoneCamera() async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      Get.snackbar("Profile Picture",
          "You have successfully captured your profile picture using camera.");
    }

    pickedFile = Rx<File?>(File(imageFile!.path));
  }

  Future<String> uploadImageToStorage(File profilePicture) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("Profile Pictures")
        .child(FirebaseAuth.instance.currentUser!.uid);

    UploadTask task = storageReference.putFile(profilePicture);
    TaskSnapshot snapshot = await task;

    String downloadURL = await snapshot.ref.getDownloadURL();

    return downloadURL;
  }

  //Get database data
  retrieveUserData() async{
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID).get().then((snapShot)
    {
      if(snapShot.exists){
        setState(() {
          //User Info
          //imageChecker = snapShot.data()!["urlImage5"];
          userImage = snapShot.data()!["profilePicture"];
          firstName = snapShot.data()!["firstName"];
          firstNameTextEditingController.text = firstName;
          lastName = snapShot.data()!["lastName"];
          lastNameTextEditingController.text = lastName;

          batchYear = snapShot.data()!["batchYear"].toString();
          batchYearTextEditingController.text = batchYear;
          genderValue = snapShot.data()!["gender"];
          gender = genderValue;
          phoneNumber = reversePhoneNumberFormat(snapShot.data()!["phoneNumber"]);
          phoneNumberTextEditingController.text = phoneNumber;
          minBudget = snapShot.data()!["minBudget"].toString();
          budgetMinController.text = minBudget;
          maxBudget = snapShot.data()!["maxBudget"].toString();
          budgetMaxController.text = maxBudget;
          leaseDurationValue = snapShot.data()!["leaseDuration"];
          leaseDuration = leaseDurationValue;
          education = snapShot.data()!["education"];
          educationTextEditingController.text = education;
          degreeProgram = snapShot.data()!["degreeProgram"];
          degreeProgramTextEditingController.text = degreeProgram;
          municipality = snapShot.data()!["municipality"];
          municipalityTextEditingController.text = municipality;
          cityOrProvince = snapShot.data()!["cityOrProvince"];
          cityOrProvinceTextEditingController.text = cityOrProvince;
          profileHeading = snapShot.data()!["profileHeading"];
          profileHeadingTextEditingController.text = profileHeading;

          //Lifestyle Preference
          numberOfRoommates = snapShot.data()!["numberOfRoommates"].toString();
          numberOfRoommatesTextEditingController.text = numberOfRoommates;
          roommateGenderValue = snapShot.data()!["roommateGender"];
          roommateGender = roommateGenderValue;
          cleanlinessValue = snapShot.data()!["cleanliness"];
          cleanliness = cleanlinessValue;
          scheduleValue = snapShot.data()!["schedule"];
          schedule = scheduleValue;
          sleepScheduleValue = snapShot.data()!["sleepSchedule"];
          sleepSchedule = sleepScheduleValue;
          smokingValue = snapShot.data()!["smoking"];
          smoking = smokingValue;
          drinkingValue = snapShot.data()!["drinking"];
          drinking = drinkingValue;
          roommateInteractionValue = snapShot.data()!["roommateInteraction"];
          roommateInteraction = roommateInteractionValue;
          guestValue = snapShot.data()!["guest"];
          guest = guestValue;
          petValue = snapShot.data()!["pet"];
          pet = petValue;
          cookingValue = snapShot.data()!["cooking"];
          cooking = cookingValue;
          quietValue = snapShot.data()!["quiet"];
          quiet = quietValue;
          interests = snapShot.data()!["interests"];
          interestsTextEditingController.text = interests;
        });
      }
    });
  }

  noProfileUpdateUserDataToFirestoreDatabase(
      //User Info
      String firstName,
      String lastName,

      //Personal Info
      String batchYear,
      String gender,
      String phoneNumber,
      String minBudget,
      String maxBudget,
      String leaseDuration,
      String education,
      String degreeProgram,
      String municipality,
      String cityOrProvince,
      String profileHeading,

      //Lifestyle Preference;
      String numberOfRoommates,
      String roommateGender,
      String cleanliness,
      String schedule,
      String sleepSchedule,
      String smoking,
      String drinking,
      String roommateInteraction,
      String guest,
      String pet,
      String cooking,
      String quiet,
      String interests) async
  {
    showDialog(
        context: context,
        builder: (context){
          return const AlertDialog(
            content: SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10,),
                    Text(
                        "Updating your profile, please wait."
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );

    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .update(
        {
          //User Info
          'firstName': firstName,
          'lastName': lastName,

          //Personal Info
          'batchYear': batchYear,
          'gender': gender,
          'phoneNumber': phoneNumber,
          'minBudget': double.parse(minBudget),
          'maxBudget': double.parse(maxBudget),
          'leaseDuration': leaseDuration,
          'education': education,
          'degreeProgram': degreeProgram,
          'municipality': municipality,
          'cityOrProvince': cityOrProvince,
          'profileHeading': profileHeading,

          //Lifestyle Preference
          'numberOfRoommates': int.parse(numberOfRoommates),
          'roommateGender': roommateGender,
          'cleanliness': cleanliness,
          'schedule': schedule,
          'sleepSchedule': sleepSchedule,
          'smoking': smoking,
          'drinking': drinking,
          'roommateInteraction': roommateInteraction,
          'guest': guest,
          'pet': pet,
          'cooking': cooking,
          'quiet': quiet,
          'interests': interests,
        });

    Get.snackbar("Update Successful", "Your account has been updated.");
    //Get.to(HomeScreen());
    Get.to(UserDetailsScreen(userID: currentUserID,));

    setState(() {
      uploading = false;
    });
  }

  updateUserDataToFirestoreDatabase(
      //User Info
      File profilePicture,
      String firstName,
      String lastName,

      //Personal Info
      String batchYear,
      String gender,
      String phoneNumber,
      String minBudget,
      String maxBudget,
      String leaseDuration,
      String education,
      String degreeProgram,
      String municipality,
      String cityOrProvince,
      String profileHeading,

      //Lifestyle Preference;
      String numberOfRoommates,
      String roommateGender,
      String cleanliness,
      String schedule,
      String sleepSchedule,
      String smoking,
      String drinking,
      String roommateInteraction,
      String guest,
      String pet,
      String cooking,
      String quiet,
      String interests) async
  {
    showDialog(
        context: context,
        builder: (context){
          return const AlertDialog(
            content: SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10,),
                    Text(
                        "Uploading images, please wait."
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );

    //await uploadImages();
    String downloadURL = await uploadImageToStorage(profilePicture);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserID)
        .update(
        {
          //User Info
          'profilePicture': downloadURL,
          'firstName': firstName,
          'lastName': lastName,

          //Personal Info
          'batchYear': batchYear,
          'gender': gender,
          'phoneNumber': phoneNumber,
          'minBudget': double.parse(minBudget),
          'maxBudget': double.parse(maxBudget),
          'leaseDuration': leaseDuration,
          'education': education,
          'degreeProgram': degreeProgram,
          'municipality': municipality,
          'cityOrProvince': cityOrProvince,
          'profileHeading': profileHeading,

          //Lifestyle Preference
          'numberOfRoommates': int.parse(numberOfRoommates),
          'roommateGender': roommateGender,
          'cleanliness': cleanliness,
          'schedule': schedule,
          'sleepSchedule': sleepSchedule,
          'smoking': smoking,
          'drinking': drinking,
          'roommateInteraction': roommateInteraction,
          'guest': guest,
          'pet': pet,
          'cooking': cooking,
          'quiet': quiet,
          'interests': interests,
        });

    Get.snackbar("Update Successful", "Your account has been updated.");
    // Get.to(HomeScreen());
    Get.to(UserDetailsScreen(userID: currentUserID,));

    setState(() {
      uploading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(39, 66, 147, 1.0),
        centerTitle: true,
        title: const Text(
          "Profile Information",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                imageFile == null
                  ? Container(
                      width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white12,
                          image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: NetworkImage(userImage.toString()),
                          ),
                        ),
                      )
                  : Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white12,
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: FileImage(
                      File(
                        imageFile!.path,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () async {
                      await pickImageFileFromGallery();
                      setState(() {
                        imageFile;
                      });
                    },
                    icon: const Icon(
                      Icons.image_outlined,
                      color: Color.fromRGBO(39, 66, 147, 1.0),
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    onPressed: () async {
                      await captureImageFromPhoneCamera();
                      setState(() {
                        imageFile;
                      });
                    },
                    icon: const Icon(
                      Icons.camera_outlined,
                      color: Color.fromRGBO(39, 66, 147, 1.0),
                      size: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              //USER INFO
              const Text(
                "User Information: ",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              //First Name
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: firstNameTextEditingController,
                  labelText: "First Name",
                  iconData: Icons.person_outline,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Last Name
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: lastNameTextEditingController,
                  labelText: "Last Name",
                  iconData: Icons.person_outline,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //PERSONAL INFO
              const Text(
                "Personal Information: ",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              //Gender
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: gender,
                  items: ['Male', 'Female', 'Non-Binary'],
                  onChanged: (String? newValue) {
                    setState(() {
                      gender = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Gender',
                  iconData: Icons.people_outline,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Phone Number
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: phoneNumberTextEditingController,
                  labelText: "Phone Number",
                  iconData: Icons.phone_outlined,
                  isObscure: false,
                  isNumberInput: true,
                  maxLength: 11,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Budget
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: RangedTextFieldWidget(
                  minEditingController: budgetMinController,
                  maxEditingController: budgetMaxController,
                  minLabelText: "Minimum budget",
                  maxLabelText: "Maximum budget",
                  iconData: Icons.money,
                  onRangeChanged: (RangeValues values) {
                    setState(() {
                      budgetRange = values; // Store the selected RangeValues
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Lease Duration
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: leaseDuration,
                  items: ['Month-to-Month', '3 Months', '6 Months', '1 Year'],
                  onChanged: (String? newValue) {
                    setState(() {
                      leaseDuration = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Lease Duration',
                  iconData: Icons.access_time_outlined,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Education
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: educationTextEditingController,
                  labelText: "University College",
                  iconData: Icons.school_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Degree Program
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: degreeProgramTextEditingController,
                  labelText: "Degree Program",
                  iconData: Icons.school_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Batch Year
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: batchYearTextEditingController,
                  labelText: "Batch Year",
                  iconData: Icons.school_outlined,
                  isObscure: false,
                  isNumberInput: true,
                  maxLength: 4,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //City or Province
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: cityOrProvinceTextEditingController,
                  labelText: "City/Province",
                  iconData: Icons.location_city_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Municipality
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: municipalityTextEditingController,
                  labelText: "Municipality",
                  iconData: Icons.location_city_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Profile Heading
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: profileHeadingTextEditingController,
                  labelText: "Profile Heading",
                  iconData: Icons.text_fields_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //LIFESTYLE PREFERENCE
              const Text(
                "Lifestyle Preference: ",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              //Number of Roommates
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: numberOfRoommatesTextEditingController,
                  labelText: "Number of Roommates",
                  iconData: Icons.people_outline,
                  isObscure: false,
                  isNumberInput: true,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Roommate Gender
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: roommateGender,
                  items: ['Male', 'Female', 'Non-Binary', 'Coed(Any gender)'],
                  onChanged: (String? newValue) {
                    setState(() {
                      roommateGender = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Roommate Gender',
                  iconData: Icons.people_outline,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Cleanliness
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: cleanliness,
                  items: ['Very Clean', 'Clean', 'Moderate', 'Messy', 'Very Messy'],
                  onChanged: (String? newValue) {
                    setState(() {
                      cleanliness = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Describe yourself in terms of cleanliness.',
                  iconData: Icons.cleaning_services,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Schedule
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: schedule,
                  items: ['Regular 9-5', 'Flexible Hours', 'Part-Time', 'Shift Work', 'Remote/Freelance'],
                  onChanged: (String? newValue) {
                    setState(() {
                      schedule = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Describe your work/class schedule.',
                  iconData: Icons.schedule_outlined,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Sleep Schedule
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: sleepSchedule,
                  items: ['Wakes up and sleeps early',
                    'Stays up late and wakes up late',
                    'Follows a consistent sleep schedule',
                    'Easily disturbed during sleep',
                    'No fixed sleep pattern'],
                  onChanged: (String? newValue) {
                    setState(() {
                      sleepSchedule = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Describe your sleeping schedule/pattern.',
                  iconData: Icons.bed_outlined,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Smoking
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: smoking,
                  items: ['Yes', 'No'],
                  onChanged: (String? newValue) {
                    setState(() {
                      smoking = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Do you smoke?',
                  iconData: Icons.smoke_free_outlined,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Drinking
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: drinking,
                  items: ['Yes', 'No'],
                  onChanged: (String? newValue) {
                    setState(() {
                      drinking = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Do you drink alcohol?',
                  iconData: Icons.local_drink_outlined,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Roommate Interaction
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: roommateInteraction,
                  items: [
                    'Very Friendly',
                    'Friendly',
                    'Neutral',
                    'Reserved',
                    'Very Reserved',
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      roommateInteraction = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Describe your interaction with your roommate.',
                  iconData: Icons.social_distance_outlined,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Guest
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: guest,
                  items: ['Yes', 'No'],
                  onChanged: (String? newValue) {
                    setState(() {
                      guest = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Do you accept/entertain guest/s?',
                  iconData: Icons.people_outline,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Pet
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: pet,
                  items: ['Yes', 'No'],
                  onChanged: (String? newValue) {
                    setState(() {
                      pet = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Do you have any pets?',
                  iconData: Icons.pets_outlined,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Cooking
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: cooking,
                  items: ['Everyday', 'Several times a week', 'Once or twice a week', 'Rarely', 'Never'],
                  onChanged: (String? newValue) {
                    setState(() {
                      cooking = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Describe how often you cook.',
                  iconData: Icons.kitchen_outlined,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Quiet
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomDropdownWidget(
                  selectedValue: quiet,
                  items: ['Very Quiet', 'Quiet', 'Moderate', 'Noisy', 'Very Noisy'],
                  onChanged: (String? newValue) {
                    setState(() {
                      quiet = newValue; // Update the selected value in the parent widget's state
                    });
                  },
                  labelText: 'Describe your noise level preference.',
                  iconData: Icons.noise_aware_outlined,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Interests
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: interestsTextEditingController,
                  labelText: "Interests",
                  iconData: Icons.videogame_asset_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //Sign Up Button
              Container(
                width: MediaQuery.of(context).size.width - 36,
                height: 50,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(39, 66, 147, 1.0),
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    )),
                child: InkWell(
                  onTap: () async {
                    //Form validator
                    //User Info
                    if (isValidPhoneNumber(phoneNumberTextEditingController.text.trim()) &&
                        firstNameTextEditingController.text
                        .trim()
                        .isNotEmpty &&
                        lastNameTextEditingController.text
                            .trim()
                            .isNotEmpty &&

                        //Personal Info
                        batchYearTextEditingController.text.trim().isNotEmpty &&
                        gender != null &&
                        phoneNumberTextEditingController.text
                            .trim()
                            .isNotEmpty &&
                        budgetMinController.text.trim().isNotEmpty &&
                        budgetMaxController.text.trim().isNotEmpty &&
                        leaseDuration != null &&
                        educationTextEditingController.text.trim().isNotEmpty &&
                        degreeProgramTextEditingController.text.trim().isNotEmpty &&
                        municipalityTextEditingController.text
                            .trim()
                            .isNotEmpty &&
                        cityOrProvinceTextEditingController.text
                            .trim()
                            .isNotEmpty &&
                        profileHeadingTextEditingController.text
                            .trim()
                            .isNotEmpty &&

                        //Lifestyle Preference
                        numberOfRoommatesTextEditingController.text.trim().isNotEmpty &&
                        roommateGender != null &&
                        cleanliness != null &&
                        schedule != null &&
                        sleepSchedule != null &&
                        smoking != null &&
                        drinking != null &&
                        roommateInteraction != null &&
                        guest != null &&
                        pet != null &&
                        cooking != null &&
                        quiet != null &&
                        interestsTextEditingController.text.trim().isNotEmpty) {

                      phoneNumberTextEditingController.text = formatPhoneNumber(phoneNumberTextEditingController.text.trim());

                      imageFile != null ?
                      //Call for creating new account
                      await updateUserDataToFirestoreDatabase(
                          //User Info
                          profilePicture!,
                          firstNameTextEditingController.text.trim(),
                          lastNameTextEditingController.text.trim(),

                          //Personal Info
                          batchYearTextEditingController.text.trim(),
                          gender!,
                          phoneNumberTextEditingController.text.trim(),
                          budgetMinController.text.trim(),
                          budgetMaxController.text.trim(),
                          leaseDuration!,
                          educationTextEditingController.text.trim(),
                          degreeProgramTextEditingController.text.trim(),
                          municipalityTextEditingController.text.trim(),
                          cityOrProvinceTextEditingController.text.trim(),
                          profileHeadingTextEditingController.text
                              .trim(),

                          //Lifestyle Preference
                          numberOfRoommatesTextEditingController.text.trim(),
                          roommateGender!,
                          cleanliness!,
                          schedule!,
                          sleepSchedule!,
                          smoking!,
                          drinking!,
                          roommateInteraction!,
                          guest!,
                          pet!,
                          cooking!,
                          quiet!,
                          interestsTextEditingController.text.trim()
                      ) : await noProfileUpdateUserDataToFirestoreDatabase(
                        //User Info
                          firstNameTextEditingController.text.trim(),
                          lastNameTextEditingController.text.trim(),

                          //Personal Info
                          batchYearTextEditingController.text.trim(),
                          gender!,
                          phoneNumberTextEditingController.text.trim(),
                          budgetMinController.text.trim(),
                          budgetMaxController.text.trim(),
                          leaseDuration!,
                          educationTextEditingController.text.trim(),
                          degreeProgramTextEditingController.text.trim(),
                          municipalityTextEditingController.text.trim(),
                          cityOrProvinceTextEditingController.text.trim(),
                          profileHeadingTextEditingController.text
                              .trim(),

                          //Lifestyle Preference
                          numberOfRoommatesTextEditingController.text.trim(),
                          roommateGender!,
                          cleanliness!,
                          schedule!,
                          sleepSchedule!,
                          smoking!,
                          drinking!,
                          roommateInteraction!,
                          guest!,
                          pet!,
                          cooking!,
                          quiet!,
                          interestsTextEditingController.text.trim()
                      );
                    } else {
                      if(isValidPhoneNumber(phoneNumberTextEditingController.text.trim()) == false){
                        Get.snackbar("Invalid Phone Number", "Please input a valid phone number.");
                      }else{
                        Get.snackbar("Something is Missing",
                            "Please fill out all required fields to complete your registration.");
                      }
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Update",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      )
    );
  }
}
