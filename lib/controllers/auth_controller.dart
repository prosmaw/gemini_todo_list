import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/model/board.dart';
import 'package:todo_list/model/user_model.dart';

class AppAuthController extends GetxController {
  UserModel? currentUser;
  bool _islogging = false;
  //List<UserModel> _boardMembers = [];
  var isLoading = false.obs;

  bool get islogging => _islogging;
  //List<UserModel> get boardMembers => _boardMembers;
  @override
  onInit() async {
    super.onInit();
    if (FirebaseAuth.instance.currentUser != null) {
      _islogging = true;
    }
  }

  Future<void> loginUser(String email, String password) async {
    isLoading.value = true;
    update();
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        _islogging = true;
        await getUserInfo();
      } else {
        _islogging = false;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    }
    isLoading.value = false;
    update();
  }

  Future<void> signUpUser(Map<String, dynamic> parameters) async {
    isLoading.value = true;
    update();
    try {
      //sign up user to firestore
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: parameters['email'], password: parameters['password']);
      //add myself board and userinfo to their collection
      if (credential.user != null) {
        _islogging = true;
        //call of add user info function
        await addUserInfo(parameters);
        //add default board
        await addDefaultBoard(parameters);
      } else {
        _islogging = false;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
    }
    isLoading.value = false;
    update();
  }

  // function to add user data to users collection
  Future<DocumentReference> addUserInfo(Map<String, dynamic> parameters) async {
    String token = await FirebaseMessaging.instance.getToken() ?? '';
    UserModel userModel = UserModel(
        email: parameters['email'],
        firstName: parameters['firstName'],
        lastName: parameters['lastName'],
        token: token);
    return FirebaseFirestore.instance
        .collection('users')
        .add(userModel.toFirestore());
  }

  Future<void> sendUserToken(String token) async {
    String token = await FirebaseMessaging.instance.getToken() ?? '';
    if (currentUser!.token != token) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser!.id)
          .update({"token": token});
    }
  }

  //add default board on user account creation
  Future<DocumentReference> addDefaultBoard(Map<String, dynamic> parameters) {
    Board board = Board(
        members: [parameters['email']],
        name: 'Myself',
        creatorEmail: parameters['email'],
        color: {'a': 255, 'r': 156, 'g': 236, 'b': 254});
    return FirebaseFirestore.instance
        .collection('boards')
        .add(board.toFirestore());
  }

  //Get current user info
  Future<void> getUserInfo() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
        .get();
    currentUser = UserModel.fromFirestore(querySnapshot.docs.single);
    currentUser!.id = querySnapshot.docs.single.id;
    await sendUserToken(currentUser!.token);
  }

  Future<bool> checkEmail(String email) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
