import 'dart:core';

class UserModel { // used to submit user data to firestore
  final String firstName;
  final String lastName;
  final String email;
  final String dob;
  final String gender;
  final String nationality;
  final List<String> languages;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dob,
    required this.gender,
    required this.nationality,
    required this.languages,
  });
  Map toMap(){
    return {
      'first_name':firstName,
      'last_name':lastName,
      'email':email,
      'dob':dob,
      'gender':gender,
      'nationality':nationality,
      'languages':languages,
    };
  }
}
