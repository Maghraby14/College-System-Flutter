import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mytask/faculties_page.dart';
import 'package:mytask/myhome_page.dart';

import 'ShimmerCard.dart';

class EngPage extends StatefulWidget {
  final int index;
  const EngPage({required this.index, super.key});

  @override
  _EngPageState createState() => _EngPageState();
}

class _EngPageState extends State<EngPage> {
  final DatabaseReference _mastersRef = FirebaseDatabase.instance.ref('Students');
  List<Map<dynamic, dynamic>> mastersList = [];
  @override
  void initState() {
    super.initState();
    _fetchData(); // Start listening for data changes
  }
  void _fetchData() {
    _mastersRef.onValue.listen((event) {
      if (!mounted) return;

      if (event.snapshot.exists) {
        if (event.snapshot.value != null && event.snapshot.value is Map<dynamic, dynamic>) {
          Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;

          setState(() {
            // Check if 'Courses' is a valid key in the data and if it contains items
            mastersList = data.entries.map((entry) {
              var courses = entry.value['Courses'] ?? [];
              // Ensure that courses[widget.index] exists and contains 'Program' and 'Engineering'
              if (courses.isNotEmpty && widget.index < courses.length && courses[widget.index]['Program'] != null) {
                return {
                  'courses': courses[widget.index]['Program']['Engineering'] ?? [],
                };
              } else {
                return {'courses': []};
              }
            }).toList();
          });

          print('mastersList length in details: ${mastersList[0]['courses']}');
          print(mastersList[0]['courses'].keys.toList());
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
  // Create a TextEditingController for the search box
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(230, 235, 250, 1),
        
      ),
      body: Container(
        color: const Color.fromRGBO(230, 235, 250, 1),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _specialization('College of Engineering'),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for anything..',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        // Trigger UI update when search field is cleared
                      });
                    },
                  )
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    // Trigger UI update when search text changes
                  });
                },
              ),
            ),
            // You can add more content here as needed, like search results, etc.
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: mastersList.isNotEmpty && mastersList[0]['courses'] != null && mastersList[0]['courses'].isNotEmpty
                      ? List.generate(mastersList[0]['courses'].length, (index) {
                    return Column(
                      children: [
                        _specialization(mastersList[0]['courses'].keys.toList()[index]),
                        const SizedBox(height: 10),
                        _degrees(mastersList[0]['courses'][mastersList[0]['courses'].keys.toList()[index]]),
                      ],
                    );
                  })
                      : [Center(child: SizedBox(
                    child: ListView.separated(itemBuilder: (context,index)=>const ShimmerCard()
                        , separatorBuilder: (context,index)=>const SizedBox(height:16), itemCount: 15),
                  )),],
                ),
              ),
            )

          ],
                 // Fallback if data is empty or null
        )
        ,
      ),
    );
  }
Row _specialization(title){
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color.fromRGBO(235, 185, 78, 1), // Color of the line
                  width: 5.0, // Thickness of the line
                ),
              ),
            ),
            child:  Text(

              title,
              style:const  TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(7, 26, 52, 1),
                fontWeight: FontWeight.bold,
              ),

            ),
          ),
        )

      ],
    );
}
  SingleChildScrollView _degrees(arr) {
    var a = arr;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(

          children: List.generate(
            a.length,
                (index) {
              // Replace with the widget you want to display for each item
              return Row(children: [_degree(a[index]['image'],a[index]['name'] ,a[index]['collage']),
              SizedBox(width: 15,)]

              );
            },
          ),
        ),
      ),
    );
  }

Column _degree(imgUrl,degree,collage){
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          borderRadius:  BorderRadius.circular(8.0),
          child:Image.network(
            imgUrl,
            width: 200,
            height: 150,
            fit: BoxFit.cover,

          ) ,
        ),
        const SizedBox(height: 5,),
        Text(degree,style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,

          color: Colors.black, // Text color
        )),
        const SizedBox(height: 2), // Add space between text and button
          Text(collage,style: const TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.bold),
        )

      ],
    );
}
  @override
  void dispose() {
    _searchController.dispose(); // Clean up the controller when the widget is removed
    super.dispose();
  }
}


