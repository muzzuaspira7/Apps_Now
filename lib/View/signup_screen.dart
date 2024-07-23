import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:now_apps/Reusable/reusable_button.dart';
import 'package:now_apps/Theme/app_colors.dart';
import 'package:now_apps/View/otp_screen.dart';

import '../Reusable/reusable_textfield.dart';

class LoginSignUpScreen extends StatefulWidget {
  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool isNewUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              AppColor.backgroundColor,
              AppColor.buttonColor,
            ],
          ),
        ),
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              height: isNewUser ? 500 : 290,
              width: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      isNewUser
                          ? 'Create Your Account Now'
                          : 'Login Your Account',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.bold,
                        color: AppColor.headingColor,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  isNewUser ? buildSignUpForm() : buildLoginForm(),
                  SizedBox(height: 10),
                  Text(
                    isNewUser
                        ? 'Already Have an Account?'
                        : 'Don\'t You Have an Account?',
                    style: GoogleFonts.openSans(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isNewUser = !isNewUser;
                      });
                    },
                    child: Text(
                      isNewUser ? 'Login Directly' : 'Create a new Account',
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginForm() {
    String phoneNumber = '';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IntlPhoneField(
            controller: numberController,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColor.backgroundColor,
              hintText: 'Phone Number',
              hintStyle: GoogleFonts.openSans(
                color: AppColor.primaryColor,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
            ),
            initialCountryCode: 'IN',
            onChanged: (phone) {
              print(phone.completeNumber);
            },
          ),
        ),
        CustomButton(
          buttonName: 'Request OTP',
          onPressed: () async {
            print('JUST');
            var usersSnapshot =
                await FirebaseFirestore.instance.collection('users').get();
            bool userExists = usersSnapshot.docs
                .any((doc) => doc['phone'] == numberController.text);

            if (userExists) {
              print('Youre exists...');
              // Optionally, you can show a message to the user
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OtpScreen(
                      email: emailController.text,
                      name: nameController.text,
                      isNew: false,
                      phone: numberController.text,
                    ),
                  ));
            } else {
              print('User does not exist');
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please Create an Account')));
            }
          },
        ),
      ],
    );
  }

  Widget buildSignUpForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ReusableTextField(
            controller: nameController,
            header: 'Enter Full Name',
            hintText: 'Full Name',
            inputFormatters: [],
          ),
          ReusableTextField(
            controller: emailController,
            header: 'Enter Email ID',
            hintText: 'Email ID',
            inputFormatters: [],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IntlPhoneField(
              controller: numberController,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColor.backgroundColor,
                hintText: 'Phone Number',
                hintStyle: GoogleFonts.openSans(
                  color: AppColor.primaryColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 15,
                ),
              ),
              initialCountryCode: 'IN',
              onChanged: (phone) {
                print(phone.completeNumber);
              },
            ),
          ),
          CustomButton(
            buttonName: 'Request OTP',
            onPressed: () async {
              print('JUST');
              var usersSnapshot =
                  await FirebaseFirestore.instance.collection('users').get();
              bool userExists = usersSnapshot.docs
                  .any((doc) => doc['phone'] == numberController.text);

              if (userExists) {
                print('Already you\'re a member');
                // Optionally, you can show a message to the user
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Already you\'re a member')));
              } else {
                print('User does not exist');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpScreen(
                        email: emailController.text,
                        name: nameController.text,
                        isNew: true,
                        phone: numberController.text,
                      ),
                    ));
              }
            },
          ),
        ],
      ),
    );
  }
}
