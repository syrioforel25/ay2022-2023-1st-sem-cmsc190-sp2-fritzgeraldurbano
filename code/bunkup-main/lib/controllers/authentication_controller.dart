import 'dart:io';

import 'package:bunkup/authenticationScreen/login_screen.dart';
import 'package:bunkup/authenticationScreen/welcome_screen.dart';
import 'package:bunkup/homeScreen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bunkup/models/person.dart' as personModel;

class AuthenticationController extends GetxController {
  static AuthenticationController authController = Get.find();

  late Rx<User?> firebaseCurrentUser;

  late Rx<File?> pickedFile;
  File? get profilePicture => pickedFile.value;
  XFile? imageFile;

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

  createNewAccount(
      //User Info
      File profilePicture,
      String firstName,
      String lastName,
      String email,
      String password,

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
      String interests) async {
    try {
      //Creates user using email and password
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      //Upload the profile picture to storage
      String downloadURL = await uploadImageToStorage(profilePicture);

      //Save user info in the firestore database
      personModel.Person personInstance = personModel.Person(
          //User Info
          uid: FirebaseAuth.instance.currentUser!.uid,
          profilePicture: downloadURL,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          matchCount: 0,

          //Personal Info
          batchYear: batchYear,
          gender: gender,
          phoneNumber: phoneNumber,
          minBudget: double.parse(minBudget),
          maxBudget: double.parse(maxBudget),
          leaseDuration: leaseDuration,
          education: education,
          degreeProgram: degreeProgram,
          municipality: municipality,
          cityOrProvince: cityOrProvince,
          profileHeading: profileHeading,
          dateCreated: DateTime.now().millisecondsSinceEpoch,

          //Lifestyle Preference
          numberOfRoommates: int.parse(numberOfRoommates),
          roommateGender: roommateGender,
          cleanliness: cleanliness,
          schedule: schedule,
          sleepSchedule: sleepSchedule,
          smoking: smoking,
          drinking: drinking,
          roommateInteraction: roommateInteraction,
          guest: guest,
          pet: pet,
          cooking: cooking,
          quiet: quiet,
          interests: interests);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(personInstance.toJson());

      Get.snackbar(
          "Account Registration Successful", "You have created your own account!");
      //Get.to(LoginScreen());
      Get.to(HomeScreen());
    } catch (errorMsg) {
      Get.snackbar(
          "Account Registration Unsuccessful", "An error occurred: $errorMsg");
    }
  }

  loginUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar("Log In Successful", "You are now logged-in.");
      Get.offAll(HomeScreen());
    } catch (errorMsg) {
      Get.snackbar("Log In Unsuccessful", "Error occurred: $errorMsg");
    }
  }

  checkUserIsLoggedIn(User? currentUser) {
    if (currentUser == null) {
      Get.offAll(LoginScreen());
    } else {
      Get.offAll(HomeScreen());
    }
  }

  @override
  void onReady() {
    super.onReady();

    firebaseCurrentUser = Rx<User?>(FirebaseAuth.instance.currentUser);
    firebaseCurrentUser.bindStream(FirebaseAuth.instance.authStateChanges());

    ever(firebaseCurrentUser, checkUserIsLoggedIn);
  }
}
