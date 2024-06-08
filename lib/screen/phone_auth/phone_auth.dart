import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneAuthPage extends StatelessWidget {
  TextEditingController col1 = TextEditingController();
  TextEditingController col2 = TextEditingController();
  TextEditingController col3 = TextEditingController();
  TextEditingController col4 = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? mVerificationId;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Form(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                controller: mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                    border: OutlineInputBorder()
                ),

              ),

              const SizedBox(height: 30),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.black,backgroundColor: Colors.amberAccent),
                  onPressed: ()async {



                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: '+91${mobileController.text}',
                      verificationCompleted: (PhoneAuthCredential credential) {
                        print('Verification Completed');
                      },
                      verificationFailed: (FirebaseAuthException e) {
                        print('FirebaseAuthException : $e');
                      },
                      codeSent: (String verificationId, int? resendToken) {
                        print('SMS sent codeSent verificationId : $verificationId \nresendToken : $resendToken');
                        mVerificationId = verificationId;
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        print('verificationId : $verificationId');
                      },
                    );




                  }, child: const Text('Send')),
              const SizedBox(height: 50),
              const Text('Enter OTP', style: TextStyle(fontSize: 20),),
              const SizedBox(height: 30),
              Row(
                children: [

                  SizedBox(
                    height: 50,
                    width: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                      textAlign: TextAlign.center,
                      controller: col1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder()
                      ),

                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                      controller: col2,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder()
                      ),

                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                      controller: col3,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder()
                      ),

                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [LengthLimitingTextInputFormatter(1),FilteringTextInputFormatter.digitsOnly],
                      controller: col4,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder()
                      ),

                    ),
                  )
                ],
              ),

              const SizedBox(height: 30),


              ElevatedButton(
                style: ElevatedButton.styleFrom(foregroundColor: Colors.black,backgroundColor: Colors.amberAccent),
                  onPressed: () async {

                  final otpPin = col1.text + col2.text + col3.text + col4.text;

                  print(otpPin);

                  String smsCode = otpPin;

                  // Create a PhoneAuthCredential with the code
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: mVerificationId!, smsCode: smsCode);

                  // Sign the user in (or link) with the credential
                  var mData =  await firebaseAuth.signInWithCredential(credential);
                  print("User Logged in : ${mData.user!.uid}");

                  }, child: const Text('Verify'))
            ],
          ),
        )

      ),
    );
  }
}
