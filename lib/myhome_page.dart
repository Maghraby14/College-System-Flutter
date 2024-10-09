import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mytask/ShimmerCard.dart';
import 'package:mytask/user_model.dart';
import 'package:mytask/user_repo.dart';
import 'detailsPage.dart';
import 'package:http/http.dart' as http;
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserRepo userRepo = Get.put(UserRepo());
  Map<String,dynamic> data = {};
/*
  void _fetchUserDetails() async {
    try {
      // Get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Call getUserDetails with the current user's email
        print('Current user email: ${user.email}');
        UserModel? userDetails = await userRepo.getUserDetails(user.email!);

        if (userDetails != null) {
          // Show user details or update the UI
          print(userDetails.name);
        } else {
          _showErrorDialog('User details not found for this email.');
        }
      } else {
        _showErrorDialog('No user is currently signed in.');
      }
    } catch (e) {
      _showErrorDialog('Error fetching user details: $e');
    }
  }
*/
  final DatabaseReference _mastersRef = FirebaseDatabase.instance.ref('Students');
  List<Map<dynamic, dynamic>> mastersList = [];

  @override
  void initState() {
    super.initState();
    _fetchData(); // Start listening for data changes
    _fettchData();
  }
  Future <void> _fettchData() async{
    const url ='https://run.mocky.io/v3/0ed12cee-b6d7-498c-bd85-e272807df96f';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      try {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

        // Set the overall data from the response
        setState(() {
          data = json;
        });

        // Search for the user whose email matches
        Map<String, dynamic>? userData;
        json.forEach((key, value) {
          if (value['email'] == currentUserEmail) {
            userData = value;
          }
        });

        // Update the state with the user-specific data if found
        if (userData != null) {
          setState(() {
            data = userData!;
          });
          print('User data: $data');
        } else {
          print('User with email $currentUserEmail not found.');
        }
      } catch (e) {
        print('Error decoding JSON: $e');
      }
    } else {
      print('Failed to fetch data or empty response.');
    }



}

  void _fetchData() {
    _mastersRef.onValue.listen((event) {
      if (!mounted) return; // Ensure the widget is still mounted before calling setState

      if (event.snapshot.exists) {
        if (event.snapshot.value != null && event.snapshot.value is Map<dynamic, dynamic>) {
          // Print the raw data to check its structure
         // print('Raw data: ${event.snapshot.value}');

          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;

          setState(() {
            mastersList = data.entries.map((entry) {
              var courses = entry.value['Courses'] ?? [];
              return {
                'courses': courses,
              };
            }).toList();

          //  print('mastersList length: ${mastersList.length}');
          });
        } else {
          _showErrorDialog('No valid data found for masters programs.');
        }
      } else {
        _showErrorDialog('No masters programs found.');
      }
    }, onError: (error) {
      _showErrorDialog('Error listening to masters data: $error');
    });
  }



  void _showUserDetailsDialog(UserModel userDetails) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('User Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${userDetails.name}'),
              Text('Email: ${userDetails.email}'),
              // Add other user details here
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
        backgroundColor: const Color.fromRGBO(230, 235, 250, 1),
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut(); // Sign out from Firebase
              } catch (e) {
                print("Sign out error: $e");
              }
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Container(
        color: const Color.fromRGBO(230, 235, 250, 1),
        padding: const EdgeInsets.all(16.0),
        child: data.isNotEmpty ? ListView.builder(
          itemCount: data['Courses'].length, // Number of courses
          itemBuilder: (context, index) {
            // Get the individual course details
            var course = data['Courses'][index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0), // Add space between items
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                ),
                onPressed: () {
                  // Navigate to the details page or perform any other action
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  DetailsPage(course: course['Program'],duration: course['Duration'],name: course['name'],faculty: course['faculty'],index: index,)),
                  );
                },
                child: Row(
                  children: <Widget>[
                    // Course Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        course['image'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Course Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          course['faculty'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined),
                            const SizedBox(width: 5),
                            Text(
                              'Duration: ${course['Duration']}',
                              style: const TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ) : Center(child: SizedBox(
          child: ListView.separated(itemBuilder: (context,index)=>const ShimmerCard()
              , separatorBuilder: (context,index)=>const SizedBox(height:16), itemCount: 15),
        )),
      ),
    );


  }
}
