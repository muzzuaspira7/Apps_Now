
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:now_apps/Model/my_cart.dart';
import 'package:now_apps/Reusable/reusable_RowText.dart';
import 'package:now_apps/Reusable/reusable_button.dart';
import 'package:now_apps/Theme/app_colors.dart';
import '../Services/database_service.dart';

class CartPage extends StatefulWidget {
  String? retailerName;
  CartPage(
    this.retailerName,
  );
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.buttonColor,
        title: Text(
          "My Cart",
          style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: _databaseService.getCart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: SizedBox(
                height: 320,
                width: double.infinity,
                child: Lottie.asset('assets/Cats No Orders.json'),
              ),
            );
          } else {
            int totalOrderPrice = 0;
            for (var cart in snapshot.data!) {
              totalOrderPrice += cart.count * cart.price;
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      myCart carts = snapshot.data![index];
                      int totalPrice = carts.count * carts.price;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
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
                                    Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Total Price : ₹ ${totalPrice.toString()}',
                                            style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            carts.name,
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
                                            'Price: ₹${carts.price.toString()}',
                                            style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: AppColor.buttonColor),
                                            ),
                                            height: 30,
                                            width: 130,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    if (carts.count > 1) {
                                                      await _databaseService
                                                          .decrementProductCount(
                                                              carts.id);
                                                      setState(() {
                                                        carts.count--;
                                                      });
                                                    }
                                                    if (carts.count == 1) {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                            "Confirm Removal",
                                                            style: GoogleFonts
                                                                .openSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                          content: const Text(
                                                            "Are you sure you want to remove this item from the cart?",
                                                          ),
                                                          actions: [
                                                            CustomButton(
                                                              buttonName:
                                                                  'Cancel',
                                                              width: 60,
                                                              height: 30,
                                                              startColor: AppColor
                                                                  .PurebackgroundColor,
                                                              endColor: AppColor
                                                                  .backgroundColor,
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                            ),
                                                            CustomButton(
                                                              buttonName:
                                                                  'Remove',
                                                              width: 70,
                                                              height: 30,
                                                              onPressed: () {
                                                                _databaseService
                                                                    .deleteProductFromCart(
                                                                        carts
                                                                            .id);
                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Container(
                                                    child: Icon(carts.count == 1
                                                        ? Icons.delete
                                                        : Icons.remove),
                                                  ),
                                                ),
                                                Text(carts.count.toString()),
                                                InkWell(
                                                  onTap: () async {
                                                    carts.count++;
                                                    if (carts.count > 1) {
                                                      setState(() {});
                                                      await _databaseService
                                                          .incrementProductCount(
                                                              carts.id);
                                                    }
                                                  },
                                                  child: const Icon(Icons.add),
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomButton(
                                            startColor: Colors.red,
                                            endColor: Colors.red,
                                            width: 120,
                                            height: 30,
                                            buttonName: 'Remove',
                                            btnTextColor: Colors.white,
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text(
                                                    "Confirm Removal",
                                                    style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    "Are you sure you want to remove this item from the cart?",
                                                  ),
                                                  actions: [
                                                    CustomButton(
                                                      buttonName: 'Cancel',
                                                      width: 60,
                                                      height: 30,
                                                      startColor: AppColor
                                                          .PurebackgroundColor,
                                                      endColor: AppColor
                                                          .backgroundColor,
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                    CustomButton(
                                                      buttonName: 'Remove',
                                                      width: 70,
                                                      height: 30,
                                                      onPressed: () {
                                                        _databaseService
                                                            .deleteProductFromCart(
                                                                carts.id);
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Bottom of the page
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price: ₹ $totalOrderPrice',
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      CustomButton(
                        width: 140,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "Confirm Order",
                                style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              content: const Text(
                                "Are you sure you want to place this order for all items?",
                              ),
                              actions: [
                                CustomButton(
                                  buttonName: 'Cancel',
                                  width: 60,
                                  height: 30,
                                  startColor: AppColor.PurebackgroundColor,
                                  endColor: AppColor.backgroundColor,
                                  onPressed: () => Navigator.pop(context),
                                ),
                                CustomButton(
                                  buttonName: 'Order All',
                                  width: 90,
                                  height: 30,
                                  onPressed: () {
                                    // Place order for all items in the Cart..
                                    for (var cartItem in snapshot.data!) {
                                      _databaseService.addOrder(
                                        cartItem.id,
                                        cartItem.name,
                                        cartItem.count,
                                        cartItem.price,
                                      );
                                      _databaseService
                                          .deleteProductFromCart(cartItem.id);
                                    }
                                    setState(() {
                                      snapshot.data!.clear();
                                    });
                                    Navigator.pop(context);

                                    
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          "Order Confirmed",
                                          style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                        content: Column(
                                          // crossAxisAlignment:
                                          //     CrossAxisAlignment.start,

                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            RowText(
                                              title: "Retailer       ",
                                              content: widget.retailerName
                                                  .toString(),
                                            ),
                                            RowText(
                                              title: "Total Price    ",
                                              content: ' ₹$totalOrderPrice',
                                            ),
                                            RowText(
                                              title: "Date           ",
                                              content:
                                                  ' ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                            ),
                                            RowText(
                                              title: "Order ID       ",
                                              content:
                                                  " ${DateTime.now().millisecondsSinceEpoch.toString()}",
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Thank you for shopping with us. We hope to see you again soon!",
                                              style: GoogleFonts.openSans(
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          CustomButton(
                                            buttonName: 'OK',
                                            width: 60,
                                            height: 30,
                                            startColor:
                                                AppColor.PurebackgroundColor,
                                            endColor: AppColor.backgroundColor,
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        buttonName: 'Order All',
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
