import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:now_apps/Model/my_order.dart';
import 'package:now_apps/Reusable/reusable_button.dart';
import 'package:now_apps/Reusable/reusable_textfield.dart';
import 'package:now_apps/Theme/app_colors.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../Drawer/drawer.dart';
import '../Services/database_service.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final TextEditingController feedback = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.buttonColor,
        title: Text(
          "My Orders",
          style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: const MyNavigationDrawer(),
      body: FutureBuilder(
        future: _databaseService.getOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: SizedBox(
                height: 320,
                width: double.infinity,
                child: Lottie.asset('assets/Cats No Orders.json'),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                myOrder orders = snapshot.data![index];
                int totalPrice = orders.count * orders.price;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColor.PurebackgroundColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: SizedBox(
                                  height: 100,
                                  width: 140,
                                  child: Image.asset(
                                    'assets/1.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    Text(
                                      orders.name,
                                      style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      '5K + bought last month',
                                      style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      'Price: \$${orders.price.toString()}',
                                      style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      'Quantity: ${orders.count.toString()}',
                                      style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    CustomButton(
                                      width: 120,
                                      height: 30,
                                      buttonName: 'Cancel Order',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SizedBox(
                                              height: 200,
                                              child: AlertDialog(
                                                title: Text(
                                                  "Confirm Order Cancellation",
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Text(
                                                        "Please provide your feedback to help us improve."),
                                                    const SizedBox(height: 15),
                                                    ReusableTextField(
                                                      height: 100,
                                                      hintText: 'Feedback',
                                                      header: 'Feedback',
                                                      controller: feedback,
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      if (feedback
                                                          .text.isNotEmpty) {
                                                        setState(() {
                                                          _databaseService
                                                              .cancleOrder(
                                                                  orders.id);
                                                          feedback.text = '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      } else {
                                                        showTopSnackBar(
                                                          Overlay.of(context),
                                                          CustomSnackBar.error(
                                                            textStyle:
                                                                GoogleFonts
                                                                    .openSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            message:
                                                                "Feedback can't be empty.",
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: const Text(
                                                      "Confirm",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Total Amount: ₹$totalPrice",
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
