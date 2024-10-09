import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytask/user_model.dart';

class UserRepo extends GetxController {
  static UserRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    try {
      // Generate a new document reference to get the auto-generated id
      final docRef = _db.collection('Users').doc();
      user.id = docRef.id; // Assign the generated id to the user model

      // Save the user data with the id included
      await docRef.set(user.toMap()).whenComplete(() {
        Get.snackbar(
          'Success',
          'Your Account has been created',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      });
    } catch (error, stackTrace) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1),
        colorText: Colors.red,
      );
      print(error.toString());
    }
  }
  Future<UserModel?> getUserDetails(String email) async {
    try {
      // Logging to check if the email is being passed correctly
      print('Fetching details for email: $email');

      final snapshot = await _db.collection('Users').where('email', isEqualTo: email).get();
      snapshot.docs.forEach((doc) {
        print('Document data: ${doc.data()}');
      });
      // Logging the size of the results to verify if it's empty or not
      print('Number of documents found: ${snapshot.docs.length}');

      if (snapshot.docs.isEmpty) {
        print('No user found for the email: $email');
        return null; // No user found
      }

      final userData = snapshot.docs.map((e) => UserModel.fromSnapShot(e)).single;
      return userData;
    } catch (e) {
      print('Error fetching user details: $e');
      return null; // Return null in case of any error
    }
  }


}

