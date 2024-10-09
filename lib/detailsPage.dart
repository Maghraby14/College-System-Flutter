// ignore: file_names
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mytask/ShimmerCard.dart';
import 'package:mytask/eng_page.dart';
import 'package:http/http.dart' as http ;
class DetailsPage extends StatefulWidget {
  final dynamic course;
  final String faculty;
  final String duration;
  final String name;
  final int index;
  const DetailsPage(
      { required this.course, required this.faculty, required this.duration, required this.name,required this.index, super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>{
  final DatabaseReference _mastersRef = FirebaseDatabase.instance.ref('Students');
  List<Map<dynamic, dynamic>> mastersList = [];
  Map<String,dynamic> data = {};
  @override
  void initState() {
    super.initState();
    _fetchData(); // Start listening for data changes
    _fettchData();
  }
  void _fettchData() async{
    const url ='https://run.mocky.io/v3/0ed12cee-b6d7-498c-bd85-e272807df96f';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      data = json ;

    });

    data.forEach((key, value) {
      if(data[key]['email']== FirebaseAuth.instance.currentUser?.email){
        data = data[key]['Courses'][widget.index]['Program'];
      }
    });
    print(data);



  }
  void _fetchData() {
    _mastersRef.onValue.listen((event) {
      if (!mounted) return; // Ensure the widget is still mounted before calling setState

      if (event.snapshot.exists) {
        if (event.snapshot.value != null && event.snapshot.value is Map<dynamic, dynamic>) {
          // Print the raw data to check its structure
          //print('Raw data: ${event.snapshot.value}');

          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;

          setState(() {
            mastersList = data.entries.map((entry) {
              var courses = entry.value['Courses'] ?? [];
              if(courses.isNotEmpty && widget.index < courses.length && courses[widget.index]['Program'] != null){
                return {
                  'courses': courses[widget.index]['Program'],
                };
              }
              else{
                return {'courses': []};
              }

            }).toList();

            //print('mastersList length in details: ${mastersList[0]['courses']['image']}');
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
      body: Container(
        color: const Color.fromRGBO(230, 235, 250, 1), // Set background color of the entire screen
        child:data.isNotEmpty && data != null && data.isNotEmpty  ? Stack(
          
          children: [
            // Background image that covers half of the screen
            Positioned(
              top: 0, // Start at the top of the screen
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.5, // Cover half of the screen height
              child: Image.network(data['image'], // Replace with your image URL
                fit: BoxFit.cover, // Ensure the image covers the half height
              ),
            ),
            // Add more widgets on top of the background image
            Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.02,
                  left: 0,
                  right: MediaQuery.of(context).size.width * 0.9,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.02,
                  left: MediaQuery.of(context).size.width * 0.7,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.only(right: 20.0), // Add margin to the right
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey, // Button background color
                        padding: const EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () => {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EngPage(index : widget.index)),
                      )
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Engineering',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 250, left: 10, right: 10),
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                         widget.name,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Text color
                        ),
                      ),
                      const SizedBox(height: 5),
                       Text(
                         widget.faculty,
                        style: TextStyle(fontSize: 17, color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                       Row(
                        children: [
                          Icon(Icons.access_time_outlined, size: 25),
                          SizedBox(width: 5),
                          Text("Duration : ${widget.duration}"
                            ,
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Curriculum',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: ListView.builder(

                          itemCount: data['sessions'].length, // Number of sessions
                          itemBuilder: (context, index) {
                            var master = data['sessions'];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.play_circle_sharp, size: 20, color: Colors.blue),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Session ${index + 1}',
                                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                      ),
                                       Text(
                                         master[index],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),

                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 80,)
                    ],
                  ),
                ),
                Stack(

                  children: [
                    Container(

                        margin: EdgeInsets.only(top:720,bottom: 7,left:10,right: 10),

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color.fromRGBO(29, 110, 194, 1)
                        ),
                        child:const Row(


                            children: [
                              Row(

                                children: [
                                  Icon(Icons.offline_bolt,color: Colors.white,),
                                ],
                              ),
                              SizedBox(width: 10,)
                              ,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text('Admit Now To Start The Program',style:TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.bold),),
                                  Text('Get 20% student discount',style:TextStyle(fontSize: 15,color: Colors.white),),
                                ],
                              ),
                              SizedBox(width: 60,),
                              Icon(Icons.forward,color: Colors.white,)
                            ]
                        )

                    )

                  ],
                )
              ],

            )
          ],
        ):Center(child: SizedBox(
          child: ListView.separated(itemBuilder: (context,index)=>const ShimmerCard()
              , separatorBuilder: (context,index)=>const SizedBox(height:16), itemCount: 15),
        )),
      ),
    );
  }


}
