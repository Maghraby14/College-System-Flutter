
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mytask/sign_in.dart';

import 'package:mytask/wrapper.dart';
import 'detailsPage.dart';
import 'package:get/get.dart';
class MySignUp extends StatefulWidget {
  const MySignUp({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  State<MySignUp> createState() => _MySignUp();
}

class _MySignUp extends State<MySignUp> {
  // int _counter = 0;
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmpasswordTextController = TextEditingController();
  late DatabaseReference  dRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dRef = FirebaseDatabase.instance.ref().child('Students');
  }

  signUp()async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text);
      Map<dynamic,dynamic> students = {
        'name':_usernameTextController.text,
        'email':FirebaseAuth.instance.currentUser?.email,
        'Courses':[{'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/NCTR_Intern_Claire_Boyle_%2815558843862%29.jpg/1024px-NCTR_Intern_Claire_Boyle_%2815558843862%29.jpg', 'name': 'Masters of Science', 'Duration': '2-5 years', 'faculty': 'Computer Science',
    "Program": {
    "image": "https://news.harvard.edu/gazette/wp-content/uploads/2022/11/iStock-mathproblems.jpg",
    "sessions": [
    "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
    "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
    "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
    "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
    "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
    "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
    "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
    "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu"
    ]
    }
        }
          ,{
            'image': 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/NCTR_Intern_Claire_Boyle_%2815558843862%29.jpg/1024px-NCTR_Intern_Claire_Boyle_%2815558843862%29.jpg', 'name': 'Masters of Maths', 'Duration': '2-5 years', 'faculty': 'Computer Engineering',
            "Program": {
              "image": "https://news.harvard.edu/gazette/wp-content/uploads/2022/11/iStock-mathproblems.jpg",
              "sessions": [
                "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
                "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
                "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
                "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
                "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
                "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
                "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu",
                "cnvlnblm;lfdm; lfdnbldkfmjdkbvkj;kfdjv;kjfn \\n v;jfbkfvbfjk;fn;kjzvfvlfzhiu"
              ]
            }
          }

        ]

      };
      dRef.push().set(students);
      Get.offAll(const Wrapper());
    }
    catch(e){
      _showErrorDialog(e.toString());
    }


  }
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // _counter++;
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: const Color.fromRGBO(230, 235, 250, 1),
        padding: const EdgeInsets.all(16.0),
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        child: SingleChildScrollView(

            child:Column(
              children: [


                _aastIcon(),
                const SizedBox(height:40 ,),
                _reusableTextField('Email', Icons.email, false, _emailTextController),
                const SizedBox(height:20 ,),
                _reusableTextField('User Name', Icons.email, false, _usernameTextController),
                const SizedBox(height:20 ,),
                _reusableTextField('Password', Icons.password, true, _passwordTextController),
                const SizedBox(height:20 ,),
                _reusableTextField('Confirm Password', Icons.password, true, _passwordTextController),
                const SizedBox(height:20 ,),
                SizedBox(
                  width: double.infinity ,
                  child:TextButton(onPressed: ()=>{

                    signUp(),

                  },
                      style: TextButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(31, 49, 100, 1), // Button background color
                          padding: const EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0))
                      ), child:const Text('Sign up',style: TextStyle(color: Colors.white,fontSize: 18),

                      )) ,
                ),
                const SizedBox(height:10 ,),
                SizedBox(

                    width: double.infinity,
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children:[
                        const Text('Already Signed in ?  ',style: TextStyle(color: Color.fromRGBO(31, 49, 100, 1),fontSize: 15),),
                        TextButton(onPressed: ()=>{
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MySignin()),
                          )
                        }, child: const Text('Log in',style: TextStyle(color: Color.fromRGBO(31, 49, 100, 1),fontSize: 17,fontWeight: FontWeight.bold),),

                        ),

                      ],
                    )
                )




              ],
            )
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),

    );

  }
}
Container _aastIcon(){
  return Container(
    margin: EdgeInsets.only(top: 100),

    child:Row(

      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        Image.asset('assets/images/aast.png',width: 150,height: 150,fit: BoxFit.cover,),
      ],
    ) ,
  );
}
TextField _reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Color.fromRGBO(31, 49, 100, 1),
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Color.fromRGBO(31, 49, 100, 0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}