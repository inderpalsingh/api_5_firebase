import 'package:api_5_firebase/screen/login_screen/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  final currentUser = FirebaseAuth.instance.currentUser;
  
  late CollectionReference userIdUser;
  String? userId;

  getUserId()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(LoginPage.USER_ID);
    print('todo page: $userId');
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 600,
            child: ListView(
              children: [
                Text('${currentUser!.uid}'),
                Text('${userIdUser.id}'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
