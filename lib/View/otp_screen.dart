import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:now_apps/Reusable/reusable_button.dart';
import 'package:now_apps/Theme/app_colors.dart';
import 'package:now_apps/View/home_screen.dart';
import 'package:pinput/pinput.dart';

import '../Services/database_service.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final String name;
  final String email;
  final bool isNew;

  OtpScreen(
      {required this.phone,
      required this.isNew,
      required this.name,
      required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late String verificationId;
  final TextEditingController _otpController = TextEditingController();
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  void initState() {
    super.initState();
    verPhoneNum(widget.phone);
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.buttonColor,
        title: Text(
          'Enter OTP Code',
          style: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColor.backgroundColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                height: 320,
                width: double.infinity,
                child: Lottie.asset('assets/login.json'),
              ),
              const SizedBox(height: 40),
              Text(
                'We Have Sent OTP on Your Number',
                textAlign: TextAlign.center,
                style: GoogleFonts.openSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              Pinput(
                controller: _otpController,
                length: 6,
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonName: 'Proceed to go',
                onPressed: () async {
                  String otpCode = _otpController.text.trim();
                  if (otpCode.length == 6) {
                    ConfirmCode(otpCode);
                    _otpController;
                  } else {
                    print('Invalid OTP length');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Verify Phone Number
  void verPhoneNum(String phone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91 $phone',
      verificationCompleted: (PhoneAuthCredential credential) {
        // Handle verification completion if auto-retrieved
        print('Verification complete');
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle verification failure
        print('Verification failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        // Save the verification ID sent to the user
        this.verificationId = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Handle timeout
        print('Verification timeout');
      },
    );
  }

  // Confirm Code
  void ConfirmCode(String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'name': widget.name,
        'email': widget.email,
        'phone': widget.phone,
        'uid': FirebaseAuth.instance.currentUser!.uid,
      });

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));

      await _databaseService.addUser(FirebaseAuth.instance.currentUser!.uid,
          widget.name, widget.email, widget.phone);
      print('added user data to the database in sql and firebase');
    } catch (e) {
      // Handle sign-in errors
      print('Sign in failed: ${e.toString()}');
      // Optionally show error to user
    }
  }
}
