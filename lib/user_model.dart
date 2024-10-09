import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  final String email;
  final String name;
  final List<String> courses; // List to hold multiple course items

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.courses,
  });
  factory UserModel.fromSnapShot(DocumentSnapshot<Map<String,dynamic>> document){
    final data = document.data();
    return UserModel(name: data?['name'], email: data?['email'], courses: data != null?['courses']:List<String>.from(data?['courses'] ?? []), id: document.id);
  }
  // You can also add a method for converting from Map if you're using Firestore or Realtime Database.
  factory UserModel.fromMap(Map<String, dynamic> map,String documentID) {
    return UserModel(
      id: documentID,
      email: map['email'] ?? '',
      courses: List<String>.from(map['courses'] ?? []), name: map['name'] ?? '', // Convert dynamic list to List<String>
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'courses': courses,
      'name':name
    };
  }
}
