import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  //Account Info
  String? uid;
  String? profilePicture;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  int? matchCount;

  //Personal Info
  String? batchYear;
  String? gender;
  String? phoneNumber;
  double? minBudget;
  double? maxBudget;
  String? leaseDuration;
  String? education;
  String? degreeProgram;
  String? municipality;
  String? cityOrProvince;
  String? profileHeading;
  int? dateCreated;

  //Lifestyle Preference;
  int? numberOfRoommates;
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
  String? interests;

  Person(
      {
      //Account info
      this.uid,
      this.profilePicture,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.matchCount,

      //Personal Info
      this.batchYear,
      this.gender,
      this.phoneNumber,
      this.minBudget,
      this.maxBudget,
      this.leaseDuration,
      this.education,
      this.degreeProgram,
      this.municipality,
      this.cityOrProvince,
      this.profileHeading,
      this.dateCreated,

      //Lifestyle Preference
      this.numberOfRoommates,
      this.roommateGender,
      this.cleanliness,
      this.schedule,
      this.sleepSchedule,
      this.smoking,
      this.drinking,
      this.roommateInteraction,
      this.guest,
      this.pet,
      this.cooking,
      this.quiet,
      this.interests
      });

  static Person fromDataSnapshot(DocumentSnapshot snapshot) {
    var dataSnapshot = snapshot.data() as Map<String, dynamic>;
    return Person(
        //User Info
        uid: dataSnapshot["uid"],
        profilePicture: dataSnapshot["profilePicture"],
        firstName: dataSnapshot["firstName"],
        lastName: dataSnapshot["lastName"],
        email: dataSnapshot["email"],
        password: dataSnapshot["password"],
        matchCount: dataSnapshot["matchCount"],

        //Personal Info
        batchYear: dataSnapshot["batchYear"],
        gender: dataSnapshot["gender"],
        phoneNumber: dataSnapshot["phoneNumber"],
        minBudget: dataSnapshot["minBudget"].toDouble(),
        maxBudget: dataSnapshot["maxBudget"].toDouble(),
        leaseDuration: dataSnapshot["leaseDuration"],
        education: dataSnapshot["education"],
        degreeProgram: dataSnapshot["degreeProgram"],
        municipality: dataSnapshot["municipality"],
        cityOrProvince: dataSnapshot["cityOrProvince"],
        profileHeading: dataSnapshot["profileHeading"],
        dateCreated: dataSnapshot["dateCreated"],

        //Lifestyle Preference
        numberOfRoommates: dataSnapshot["numberOfRoommates"],
        roommateGender: dataSnapshot["roommateGender"],
        cleanliness: dataSnapshot["cleanliness"],
        schedule: dataSnapshot["schedule"],
        sleepSchedule: dataSnapshot["sleepSchedule"],
        smoking: dataSnapshot["smoking"],
        drinking: dataSnapshot["drinking"],
        roommateInteraction: dataSnapshot["roommateInteraction"],
        guest: dataSnapshot["guest"],
        pet: dataSnapshot["pet"],
        cooking: dataSnapshot["cooking"],
        quiet: dataSnapshot["quiet"],
        interests: dataSnapshot["interests"],
        );
  }

  Map<String, dynamic> toJson() => {
        //User Info
        "uid": uid,
        "profilePicture": profilePicture,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "matchCount": matchCount,

        //Personal Info
        "batchYear": batchYear,
        "gender": gender,
        "phoneNumber": phoneNumber,
        "minBudget": minBudget,
        "maxBudget": maxBudget,
        "leaseDuration": leaseDuration,
        "education": education,
        "degreeProgram": degreeProgram,
        "municipality": municipality,
        "cityOrProvince": cityOrProvince,
        "profileHeading": profileHeading,
        "dateCreated": dateCreated,

        //Lifestyle Preference
        "numberOfRoommates": numberOfRoommates,
        "roommateGender": roommateGender,
        "cleanliness": cleanliness,
        "schedule": schedule,
        "sleepSchedule": sleepSchedule,
        "smoking": smoking,
        "drinking": drinking,
        "roommateInteraction": roommateInteraction,
        "guest": guest,
        "pet": pet,
        "cooking": cooking,
        "quiet": quiet,
        "interests": interests,
      };
}
