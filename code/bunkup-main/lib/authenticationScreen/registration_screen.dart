import 'dart:io';

import 'package:bunkup/authenticationScreen/login_screen.dart';
import 'package:bunkup/controllers/authentication_controller.dart';
import 'package:bunkup/widgets/ranged_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/dropdown_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //User Info
  TextEditingController firstNameTextEditingController = TextEditingController();
  TextEditingController lastNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();

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

  bool showProgressBar = false;
  var authenticationController = AuthenticationController.authController;

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0') && phoneNumber.length == 11) {
      return '+63' + phoneNumber.substring(1);
    }
    // Return the original number if it doesn't match the expected format
    return phoneNumber;
  }

  bool isValidPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^(0|\+63)9\d{9}$');
    return regex.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "to get Started Now.",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              //Choose profile picture
              authenticationController.imageFile == null
                  ? const CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage("images/profile_avatar.png"),
                      backgroundColor: Colors.white12,
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
                              authenticationController.imageFile!.path,
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
                      await authenticationController.pickImageFileFromGallery();
                      setState(() {
                        authenticationController.imageFile;
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
                      await authenticationController
                          .captureImageFromPhoneCamera();
                      setState(() {
                        authenticationController.imageFile;
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
              //Email
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: emailTextEditingController,
                  labelText: "Email",
                  iconData: Icons.email_outlined,
                  isObscure: false,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Password
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: passwordTextEditingController,
                  labelText: "Password",
                  iconData: Icons.lock_outline,
                  isObscure: true,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              //Confirm Password
              SizedBox(
                width: MediaQuery.of(context).size.width - 36,
                height: 55,
                child: CustomTextFieldWidget(
                  editingController: confirmPasswordTextEditingController,
                  labelText: "Confirm Password",
                  iconData: Icons.lock_outline,
                  isObscure: true,
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
                  minLabelText: "Min. rent budget",
                  maxLabelText: "Max. rent budget",
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
                  labelText: "University/College",
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
                    if (authenticationController.imageFile != null) {
                      //User Info
                      if (isValidPhoneNumber(phoneNumberTextEditingController.text.trim()) &&
                          firstNameTextEditingController.text
                              .trim()
                              .isNotEmpty &&
                          lastNameTextEditingController.text
                              .trim()
                              .isNotEmpty &&
                          emailTextEditingController.text.trim().isNotEmpty &&
                          passwordTextEditingController.text
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
                        setState(() {
                          filterBatchYear = batchYearTextEditingController.text.trim().toString();
                          filterGender = roommateGender!.toString();
                          filterLeaseDuration = leaseDuration!.toString();
                          filterNumberOfRoommates = numberOfRoommatesTextEditingController.text.trim().toString();
                          filterCleanliness = cleanliness!.toString();
                          filterSchedule = schedule!.toString();
                          filterSleepSchedule = sleepSchedule!.toString();
                          filterSmoking = smoking!.toString();
                          filterDrinking = drinking!.toString();
                          filterRoommateInteraction = roommateInteraction!.toString();
                          filterGuest = guest!.toString();
                          filterPet = pet!.toString();
                          filterCooking = cooking!.toString();
                          filterQuiet = quiet!.toString();
                          filterMaxBudget = budgetMaxController.text.trim().toString();
                          filterMinBudget = budgetMinController.text.trim().toString();
                          isNewUser = true;
                        });
                        if(passwordTextEditingController.text.trim() == confirmPasswordTextEditingController.text.trim()){
                          setState(() {
                            showProgressBar = true;
                          });

                          phoneNumberTextEditingController.text = formatPhoneNumber(phoneNumberTextEditingController.text.trim());

                          //Call for creating new account
                          await authenticationController.createNewAccount(
                              authenticationController.profilePicture!,
                              //User Info
                              firstNameTextEditingController.text.trim(),
                              lastNameTextEditingController.text.trim(),
                              emailTextEditingController.text.trim(),
                              passwordTextEditingController.text.trim(),

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
                              interestsTextEditingController.text.trim());
                          setState(() {
                            showProgressBar = false;
                            authenticationController.imageFile = null;
                          });
                        }else{
                          Get.snackbar("Password Mismatch",
                              "Passwords do not match. Please try again.");
                        }
                      } else {
                        if(isValidPhoneNumber(phoneNumberTextEditingController.text.trim()) == false){
                          Get.snackbar("Invalid Phone Number", "Please input a valid phone number.");
                        }else{
                          Get.snackbar("Something is Missing",
                              "Please fill out all required fields to complete your registration.");
                        }
                      }
                    } else {
                      Get.snackbar("Profile Picture Missing",
                          "Please select a profile picture from gallery or capture from your device.");
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Create Account",
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
              //Already have an account, Log In here
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(LoginScreen());
                    },
                    child: const Text(
                      "Log in here.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(39, 66, 147, 1.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              showProgressBar == true
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color.fromRGBO(39, 66, 147, 1.0)),
                    )
                  : Container(),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
