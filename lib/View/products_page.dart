import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:now_apps/Reusable/reusable_alertDialog.dart';
import 'package:now_apps/Reusable/reusable_textfield.dart';
import 'package:now_apps/Theme/app_colors.dart';
import 'package:now_apps/View/cart_page.dart';
import 'package:now_apps/View/home_screen.dart';
import 'package:now_apps/View/product_detail.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../Model/miniProduct.dart';
import '../Provider/count_feedback.dart';
import '../Reusable/reusable_button.dart';
import '../Services/database_service.dart';

class ProductsPage extends StatefulWidget {
  bool Checkin = true;
  final String name;
  int fbCount = 0;
  ProductsPage(
      {super.key,
      required this.name,
      required this.Checkin,
      required this.fbCount});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final DatabaseService _databaseService = DatabaseService.instance;
  TextEditingController fbController = TextEditingController();

  @override
  void initState() {
    print(widget.Checkin);
    super.initState();
    if (widget.Checkin) {
      _saveLastScreen();
    }
  }

  Future<void> _saveLastScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_screen', 'ProductsPage');
    await prefs.setString('last_screen_name', widget.name);
  }

  Future<void> _deleteLastScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_screen');
    await prefs.remove('last_screen_name');
  }

  Future<void> _showCheckOutDialog() async {
    final countFeedback = Provider.of<CountFeedback>(context, listen: false);
    if (countFeedback.cartCount == 0) {
      _showFeedbackDialog();
    } else {
      return await showDialog(
        context: context,
        builder: (context) => CustomAlertDialog(
          title: "Check Out Alert",
          content: "Are you sure you want to proceed with the checkout?",
          cancelText: "Cancel",
          confirmText: "Ok",
          onCancel: () => Navigator.pop(context),
          onConfirm: () {
            setState(() {
              widget.Checkin = false;
            });
            _deleteLastScreen();
            countFeedback.reset();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      );
    }
  }

  Future<void> _showFeedbackDialog() async {
    final countFeedback = Provider.of<CountFeedback>(context, listen: false);
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Feedback Required",
          style:
              GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "To proceed without placing an order, your feedback is needed.",
              style: GoogleFonts.openSans(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            ReusableTextField(
                hintText: "Feedback",
                header: "Enter the Feedback",
                controller: fbController)
          ],
        ),
        actions: [
          CustomButton(
            buttonName: "Cancle",
            width: 60,
            height: 30,
            startColor: AppColor.PurebackgroundColor,
            endColor: AppColor.backgroundColor,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          CustomButton(
            buttonName: "Submit & Checkout",
            width: 150,
            height: 30,
            onPressed: () {
              if (fbController.text != "") {
                setState(() {
                  widget.Checkin = false;
                  _deleteLastScreen();
                  countFeedback.reset();
                });

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              } else {
                showTopSnackBar(
                  Overlay.of(context),
                  const CustomSnackBar.error(
                    message: "Feedback Cant be Empty",
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

//  for te toast message
  Future<bool> _showToastmsg(String msg) async {
    showToast(msg,
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 5),
        context: context,
        borderRadius: BorderRadius.circular(20));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColor.headingColor,
          onPressed: () {
            _showCheckOutDialog();
          },
          label: Text(
            'Check Out',
            style: GoogleFonts.openSans(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          )),
      appBar: AppBar(
        backgroundColor: AppColor.buttonColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.name}'s Products",
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(widget.name),
                      ));
                },
                icon: const Icon(
                  Icons.shopify_sharp,
                  size: 30,
                ))
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          return _showToastmsg('Checkout to be redirected to the Home screen.');
        },
        child: FutureBuilder<List<ProductModel>>(
          future: _databaseService.getProductsFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products available.'));
            } else {
              print('LENGTHHHHHHHHHHHHHHHHHHHHHH');
              print(snapshot.data!.length);
              final products = snapshot.data!;

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return FutureBuilder<bool>(
                    future: _databaseService.isProductInCart(product.prodId),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      } else {
                        final isInCart = snapshot.data ?? false;
                        print("IS INCART: ${isInCart}");
                        return FutureBuilder<int>(
                          future: isInCart
                              ? _databaseService.getProductCount(product.prodId)
                              : Future.value(0),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox();
                            } else {
                              final cartCount = snapshot.data ?? 0;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductDetail(
                                          product: product,
                                          retailerName: widget.name,
                                          CartButton: true,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.backgroundColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset('assets/1.jpg'),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            product.prodName,
                                            style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '₹${product.prodPrice}',
                                                style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              if (isInCart)
                                                SizedBox(
                                                    height: 45,
                                                    width: 45,
                                                    child: Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        const Icon(
                                                            Icons.shopify),
                                                        Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child: Container(
                                                            height: 20,
                                                            width: 20,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                color: AppColor
                                                                    .headingColor),
                                                            child: Center(
                                                              child: Text(
                                                                '$cartCount',
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
