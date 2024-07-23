import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:now_apps/Reusable/reusable_alertDialog.dart';
import 'package:now_apps/Reusable/reusable_button.dart';
import 'package:now_apps/Theme/app_colors.dart';
import 'package:now_apps/View/cart_page.dart';
import 'package:now_apps/View/home_screen.dart';
import 'package:now_apps/View/product_detail.dart';
import '../Model/miniProduct.dart';
import '../Services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsPage extends StatefulWidget {
  final String name;
  const ProductsPage({super.key, required this.name});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _showExitConfirmationDialog() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Confirmation'),
            content: const Text(
                'You will check out from this product. Are you sure you want to exit?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('OK'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _showCheckOutDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: "Check Out Alert",
        content: "Are you sure you want to proceed with the checkout?",
        cancelText: "Cancel",
        confirmText: "Ok",
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
      ),
    );
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
              // 'Products',
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
                icon: Icon(
                  Icons.shopify_sharp,
                  size: 30,
                ))
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "Check Out Alert",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, fontSize: 17),
              ),
              content: Text(
                "Are you sure you want to proceed with the checkout?",
              ),
              actions: [
                CustomButton(
                  buttonName: 'Cancle',
                  width: 60,
                  height: 30,
                  startColor: AppColor.PurebackgroundColor,
                  endColor: AppColor.backgroundColor,
                  onPressed: () => Navigator.pop(context),
                ),
                CustomButton(
                    buttonName: 'Ok',
                    width: 60,
                    height: 30,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ));
                    }),
              ],
            ),
          );
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
              final products = snapshot.data!;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
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
                              Text(
                                '₹${product.prodPrice}',
                                style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
