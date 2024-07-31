import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:now_apps/Theme/app_colors.dart';
import 'package:now_apps/View/cart_page.dart';
import 'package:provider/provider.dart';
import '../Model/miniProduct.dart';
import '../Provider/count_feedback.dart';
import '../Reusable/reusable_button.dart';
import '../Services/database_service.dart';

class ProductDetail extends StatefulWidget {
  final ProductModel product;
  String retailerName;
  bool CartButton;

  ProductDetail(
      {required this.product,
      required this.retailerName,
      required this.CartButton});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final DatabaseService _databaseService = DatabaseService.instance;

  bool isCart = false;
  int count = 0;

  @override
  void initState() {
    super.initState();
    _initializeCartStatus();
  }

  void _initializeCartStatus() async {
    bool productInCart =
        await _databaseService.isProductInCart(widget.product.prodId);
    if (productInCart) {
      int currentCount =
          await _databaseService.getProductCount(widget.product.prodId);
      setState(() {
        isCart = true;
        count = currentCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final countFeedback = Provider.of<CountFeedback>(context);
    return Scaffold(
      backgroundColor: AppColor.PurebackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.buttonColor,
        title: Text(
          'Detailed View',
          style: GoogleFonts.openSans(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/1.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Text(
                widget.product.prodName,
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(
                height: 5,
              ),

              Text(
                "Price: ₹ ${widget.product.prodPrice}",
                style: GoogleFonts.openSans(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(
                height: 5,
              ),
              Text(
                'Experience the elegance and functionality of our Premium Leather Wallet, meticulously crafted from 100% genuine leather. This wallet combines style and utility with multiple card slots, cash pockets, and an ID window, all in a compact design. Its RFID blocking technology ensures your information stays safe, while the durable stitching guarantees long-lasting use. Perfect for any occasion, this classic black wallet offers both sophistication and practicality, making it an essential accessory for everyday use.',
                style: GoogleFonts.openSans(fontSize: 15),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Delivery Options',
                style: GoogleFonts.openSans(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '⭐ Standard Shipping: 3-5 business days',
                style: GoogleFonts.openSans(fontSize: 16),
              ),

              Text(
                '⭐ Express Shipping: 1-2 business days',
                style: GoogleFonts.openSans(fontSize: 16),
              ),

              Text(
                '⭐ Free In-Store Pickup',
                style: GoogleFonts.openSans(fontSize: 16),
              ),

              /// Button...
              const SizedBox(
                height: 10,
              ),

              widget.CartButton == true
                  ? count == 0
                      ? CustomButton(
                          buttonName: 'Add to cart',
                          // width: 130,
                          onPressed: () async {
                            if (!await _databaseService
                                .isProductInCart(widget.product.prodId)) {
                              String strPrice = widget.product.prodPrice;
                              double doubleValue = double.parse(strPrice);
                              int prodPrice = doubleValue.toInt();
                              print(widget.product.prodPrice);
                              print("INT one... ${widget.product.prodPrice}");
                              await _databaseService.addCart(
                                  widget.product.prodId,
                                  widget.product.prodName,
                                  1,
                                  prodPrice,
                                  widget.retailerName);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Item Added',
                                autoHide: const Duration(seconds: 10),
                                desc:
                                    'The item was successfully added to your shopping cart.',
                                btnCancelOnPress: () {},
                                btnOkText: 'Go to Cart',
                                btnCancelText: 'Back',
                                btnCancelColor: Colors.grey[400],
                                btnOkOnPress: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CartPage(widget.retailerName),
                                      ));
                                },
                              ).show();
                            }
                            if (count == 0) {
                              setState(() {
                                count = 1;
                                countFeedback.add(1);
                              });
                            }
                          },
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColor.backgroundColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    if (count > 1) {
                                      await _databaseService
                                          .decrementProductCount(
                                              widget.product.prodId);
                                      setState(() {
                                        count--;
                                        countFeedback.decrement(1);
                                      });
                                    } else if (count == 1) {
                                      setState(() {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.question,
                                          animType: AnimType.leftSlide,
                                          title: 'Remove Item',
                                          desc:
                                              'Are you sure you want to remove this item from the cart?',
                                          btnCancelOnPress: () {},
                                          btnOkText: 'Remove',
                                          btnOkOnPress: () {
                                            _databaseService
                                                .deleteProductFromCart(
                                                    widget.product.prodId);
                                            setState(() {
                                              count = 0;
                                              countFeedback.decrement(1);
                                            });
                                          },
                                        ).show();
                                      });
                                    }
                                  },
                                  icon: Icon(
                                    count > 1 ? Icons.remove : Icons.delete,
                                    color:
                                        count < 1 ? Colors.red : Colors.black,
                                  ),
                                ),
                                Text(
                                  'Quantity - $count',
                                  style: GoogleFonts.openSans(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await _databaseService
                                        .incrementProductCount(
                                            widget.product.prodId);
                                    setState(() {
                                      count++;
                                      countFeedback.add(1);
                                    });
                                  },
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
