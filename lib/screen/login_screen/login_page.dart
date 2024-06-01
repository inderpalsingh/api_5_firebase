import 'package:api_5_firebase/screen/todo_screen/todo_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  
  static String USER_ID='UID';
  
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade300,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passController,
              decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.lock_open_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () async {
                  
                  try{
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passController.text.toString(),
                        
                    ).then((value)async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString(USER_ID, value.user!.uid);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TodoPage()));
                    });

                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  }

                 
            }, child: const Text('Login',style: TextStyle(color: Colors.black)))
          ],
        ),
      ),
    );
  }
}
