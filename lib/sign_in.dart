import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytask/sign_up.dart';
import 'detailsPage.dart';

class MySignin extends StatefulWidget {
  const MySignin({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".



  @override
  State<MySignin> createState() => _MySigninState();
}

class _MySigninState extends State<MySignin> {
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
  // int _counter = 0;
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
 signIn()async {
   try{
     await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text);

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
                _reusableTextField('Password', Icons.password, true, _passwordTextController),
                const SizedBox(height:20 ,),
                SizedBox(
                  width: double.infinity ,
                  child:TextButton(onPressed: ()=>{
                    signIn()
                  },
                      style: TextButton.styleFrom(
                          backgroundColor: Color.fromRGBO(31, 49, 100, 1), // Button background color
                          padding: const EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.0))
                      ), child:const Text('Log in',style: TextStyle(color: Colors.white,fontSize: 18),

                      )) ,
                ),
                const SizedBox(height:10 ,),
                SizedBox(

                 width: double.infinity,
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children:[
                    const Text('Not Signed in yet ?  ',style: TextStyle(color: Color.fromRGBO(31, 49, 100, 1),fontSize: 15),),
                    TextButton(onPressed: ()=>{
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MySignUp()),
                    )
                    }, child: const Text('SignUp',style: TextStyle(color: Color.fromRGBO(31, 49, 100, 1),fontSize: 17,fontWeight: FontWeight.bold),),

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
    margin: EdgeInsets.only(top: 150),

    child:Row(

      mainAxisAlignment: MainAxisAlignment.center,
      
      children: [
        Image.asset('assets/images/aast.png',width: 200,height: 200,fit: BoxFit.cover,),
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