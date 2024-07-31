import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:now_apps/Model/my_cart.dart';
import 'package:now_apps/Reusable/reusable_RowText.dart';
import 'package:now_apps/Reusable/reusable_button.dart';
import 'package:now_apps/Theme/app_colors.dart';
import 'package:provider/provider.dart';
import '../Provider/checkbox.dart';
import '../Provider/count_feedback.dart';
import '../Services/database_service.dart';

class CartPage extends StatefulWidget {
  String? retailerName;
  CartPage(this.retailerName);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final DatabaseService _databaseService = DatabaseService.instance;
  bool isFilter = false;

  @override
  Widget build(BuildContext context) {
    final countFeedback = Provider.of<CountFeedback>(context, listen: false);
    final checkboxStatus = Provider.of<CheckboxStatus>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.buttonColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Cart",
              style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
            ),
            InkWell(
                onTap: () {
                  setState(() {
                    isFilter = false;
                  });
                },
                child: const Icon(Icons.filter_alt_outlined))
          ],
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
            final filterCart = snapshot.data!
                .where((cart) => cart.retailer == widget.retailerName)
                .toList();
            int totalOrderPrice = 0;
            for (var cart in filterCart) {
              totalOrderPrice += cart.count * cart.price;
            }

            int totalSelectedPrice = filterCart
                .where((item) => checkboxStatus.isSelected(item.id))
                .fold(0, (sum, item) => sum + (item.count * item.price));

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filterCart.length,
                    itemBuilder: (context, index) {
                      myCart carts = filterCart[index];
                      int totalPrice = carts.count * carts.price;

                      return InkWell(
                        onLongPress: () {
                          setState(() {
                            isFilter = true;
                          });
                        },
                        child: Padding(
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
                                  Row(
                                    children: [
                                      isFilter
                                          ? Checkbox(
                                              value: checkboxStatus
                                                  .isSelected(carts.id),
                                              onChanged: (value) {
                                                checkboxStatus
                                                    .toggleSelection(carts.id);
                                                setState(() {});
                                              },
                                            )
                                          : const SizedBox(),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: Text(
                                                'Retailer : ${carts.retailer}',
                                                style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: Text(
                                                'Total Price : ₹ ${totalPrice.toString()}',
                                                style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
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
                                                    color:
                                                        AppColor.buttonColor),
                                              ),
                                              height: 30,
                                              width: 130,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      if (carts.count > 1) {
                                                        await _databaseService
                                                            .decrementProductCount(
                                                                carts.id);
                                                        setState(() {
                                                          carts.count--;
                                                          countFeedback
                                                              .decrement(1);
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
                                                                  countFeedback
                                                                      .decrement(
                                                                          carts
                                                                              .count);
                                                                  setState(
                                                                      () {});
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
                                                      child: Icon(
                                                          carts.count == 1
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
                                                        countFeedback.add(1);
                                                      }
                                                    },
                                                    child:
                                                        const Icon(Icons.add),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            isFilter == false
                                                ? CustomButton(
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
                                                                countFeedback
                                                                    .decrement(carts
                                                                        .count);
                                                                setState(() {});
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  )
                                                : const SizedBox()
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
                        ),
                      );
                    },
                  ),
                ),
                // Bottom of the page
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
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
                                        for (var cartItem in filterCart) {
                                          _databaseService.addOrder(
                                              cartItem.id,
                                              cartItem.name,
                                              cartItem.count,
                                              cartItem.price,
                                              cartItem.retailer);
                                          _databaseService
                                              .deleteProductFromCart(
                                                  cartItem.id);
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
                                                const SizedBox(height: 10),
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
                                                startColor: AppColor
                                                    .PurebackgroundColor,
                                                endColor:
                                                    AppColor.backgroundColor,
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
                      isFilter
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                  width: 140,
                                  onPressed: () {
                                    List<myCart> selectedItems = filterCart
                                        .where((item) =>
                                            checkboxStatus.isSelected(item.id))
                                        .toList();
                                    int totalSelectedPrice = selectedItems.fold(
                                        0,
                                        (sum, item) =>
                                            sum + (item.count * item.price));

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
                                        content: Text(
                                          "Are you sure you want to place this order for selected items? Total Price: ₹ $totalSelectedPrice",
                                        ),
                                        actions: [
                                          CustomButton(
                                            buttonName: 'Cancel',
                                            width: 60,
                                            height: 30,
                                            startColor:
                                                AppColor.PurebackgroundColor,
                                            endColor: AppColor.backgroundColor,
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          CustomButton(
                                            buttonName: 'Order Selected',
                                            width: 90,
                                            height: 30,
                                            onPressed: () {
                                              for (var cartItem
                                                  in selectedItems) {
                                                _databaseService.addOrder(
                                                    cartItem.id,
                                                    cartItem.name,
                                                    cartItem.count,
                                                    cartItem.price,
                                                    cartItem.retailer);
                                                _databaseService
                                                    .deleteProductFromCart(
                                                        cartItem.id);
                                              }
                                              setState(() {
                                                snapshot.data!.removeWhere(
                                                    (item) => selectedItems
                                                        .contains(item));
                                              });
                                              checkboxStatus.clearSelections();
                                              Navigator.pop(context);

                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text(
                                                    "Order Confirmed",
                                                    style: GoogleFonts.openSans(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      RowText(
                                                        title:
                                                            "Retailer       ",
                                                        content: widget
                                                            .retailerName
                                                            .toString(),
                                                      ),
                                                      RowText(
                                                        title:
                                                            "Total Price    ",
                                                        content:
                                                            ' ₹$totalSelectedPrice',
                                                      ),
                                                      RowText(
                                                        title:
                                                            "Date           ",
                                                        content:
                                                            ' ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                                      ),
                                                      RowText(
                                                        title:
                                                            "Order ID       ",
                                                        content:
                                                            " ${DateTime.now().millisecondsSinceEpoch.toString()}",
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      Text(
                                                        "Thank you for shopping with us. We hope to see you again soon!",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          fontStyle:
                                                              FontStyle.italic,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    CustomButton(
                                                      buttonName: 'OK',
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
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  buttonName: 'Order Selected',
                                ),
                                CustomButton(
                                  startColor: Colors.red,
                                  endColor: Colors.red,
                                  btnTextColor: AppColor.PurebackgroundColor,
                                  width: 140,
                                  onPressed: () {
                                    List<myCart> selectedItems = filterCart
                                        .where((item) =>
                                            checkboxStatus.isSelected(item.id))
                                        .toList();

                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                          "Confirm Removal",
                                          style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                        content: const Text(
                                          "Are you sure you want to remove the selected items from the cart?",
                                        ),
                                        actions: [
                                          CustomButton(
                                            buttonName: 'Cancel',
                                            width: 60,
                                            height: 30,
                                            startColor:
                                                AppColor.PurebackgroundColor,
                                            endColor: AppColor.backgroundColor,
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          CustomButton(
                                            buttonName: 'Remove',
                                            width: 90,
                                            height: 30,
                                            onPressed: () {
                                              for (var cartItem
                                                  in selectedItems) {
                                                _databaseService
                                                    .deleteProductFromCart(
                                                        cartItem.id);
                                                countFeedback
                                                    .decrement(cartItem.count);
                                              }
                                              setState(() {
                                                snapshot.data!.removeWhere(
                                                    (item) => selectedItems
                                                        .contains(item));
                                              });

                                              checkboxStatus.clearSelections();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  buttonName: 'Remove Selected',
                                ),
                              ],
                            )
                          : const SizedBox(),
                      isFilter
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Total Price for Selected Items: ₹ $totalSelectedPrice',
                                style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : const SizedBox()
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
