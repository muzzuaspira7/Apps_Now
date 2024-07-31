import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:now_apps/Reusable/reusable_button.dart';
import 'package:now_apps/Reusable/reusable_textfield.dart';
import 'package:now_apps/Theme/app_colors.dart';
import 'package:now_apps/View/home_screen.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:geolocator/geolocator.dart';

import '../Services/database_service.dart';

class RetailerForm extends StatefulWidget {
  const RetailerForm({super.key});

  @override
  State<RetailerForm> createState() => _RetailerFormState();
}

class _RetailerFormState extends State<RetailerForm> {
  // Defining variables & controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  // bool widgetBuild = false;
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.buttonColor,
        title: Text(
          'Retailer Form',
          style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: AlertDialog(
            content: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.backgroundColor),
              ),
              child: Material(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Register New Retailer',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColor.headingColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Name
                      ReusableTextField(
                        hintText: 'Name',
                        header: 'Enter Name',
                        controller: nameController,
                      ),
                      // Address
                      ReusableTextField(
                        hintText: 'Address',
                        header: 'Enter Your Full Address',
                        controller: addressController,
                      ),
                      // Contact
                      ReusableTextField(
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        isNumeric: true,
                        hintText: 'Contact Number',
                        header: 'Phone Number',
                        controller: contactController,
                      ),
                      // Location
                      Row(
                        children: [
                          Expanded(
                            child: ReusableTextField(
                              hintText: 'Location',
                              header: 'Your Location',
                              controller: locationController,
                            ),
                          ),
                          CustomButton(
                            width: 80,
                            height: 39,
                            fontSize: 10,
                            buttonName: 'Get Location',
                            onPressed: () {
                              print('CLICK');
                              _getCurrentLocation(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      CustomButton(
                        buttonName: 'Submit',
                        onPressed: () async {
                          if (addressController.text.isNotEmpty &&
                              locationController.text.isNotEmpty &&
                              contactController.text.isNotEmpty &&
                              nameController.text.isNotEmpty) {
                            await _databaseService.addRetailRegister(
                                nameController.text,
                                contactController.text,
                                addressController.text,
                                locationController.text);
                            showTopSnackBar(
                              Overlay.of(context),
                              const CustomSnackBar.success(
                                message:
                                    "Successfully Added Your Form as Retailer",
                              ),
                            );
                            addressController.clear();
                            locationController.clear();
                            contactController.clear();
                            nameController.clear();
                            setState(() {});
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ));
                          } else {
                            showTopSnackBar(
                              Overlay.of(context),
                              const CustomSnackBar.error(
                                message: "All fields are Mandatory",
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation(BuildContext context) async {
    print("Enter the Permission Function+");
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Service Enbled")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Service disabled/")));
    }
    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      locationController.text = '${position.latitude}, ${position.longitude}';
      // widgetBuild = true;
    });
  }
}
