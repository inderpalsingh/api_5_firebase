import 'package:api_5_firebase/model/user_model.dart';
import 'package:api_5_firebase/screen/login_screen/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SignupPage extends StatelessWidget {
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passController = TextEditingController();
  
  late CollectionReference mUsers;
  
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  
  

  @override
  Widget build(BuildContext context) {
    
    mUsers = firestore.collection('users');
    
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade300,
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: 'Name',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person_2_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                  hintText: 'Age',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.directions_walk),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      
                     try{
                       
                       final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                           email: emailController.text.toString(),
                           password: passController.text.toString(),
                       );
                       
                      print(credential.user!.uid);
                        
                       UserModel userModel = UserModel(
                           name: nameController.text.toString(),
                           email: emailController.text.toString(),
                           age: int.parse(ageController.text.toString()),
                           pass: passController.text.toString()
                       );

                      mUsers.doc(credential.user!.uid).set(userModel.toMapDoc()).then((value){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      });

                     } on FirebaseAuthException catch (e) {
                       if (e.code == 'weak-password') {
                         print('The password provided is too weak.');
                       } else if (e.code == 'email-already-in-use') {
                         print('The account already exists for that email.');
                       }
                     } catch (e) {
                       print(e);
                     }
                
                    }, child: const Text('Signup',style: TextStyle(color: Colors.black))),

                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                    child: const Text('Already have account ?', style: TextStyle(color: Colors.white),)),
                
              ],
            )
          ],
        ),
      ),
    );
  }
}
