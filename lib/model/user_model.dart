import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String firstName, lastName;
  String email;
  String? profile;
  String token;
  String? id;
  UserModel(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.token,
      this.profile});

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profile': profile,
      'token': token,
    };
  }

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    String userProfile = "";
    if (data!.containsKey('profile') && data['profile'] != null) {
      userProfile = data['profile'];
    }
    return UserModel(
        email: data['email'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        profile: userProfile,
        token: data['token']);
  }
}
