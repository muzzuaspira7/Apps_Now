import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:now_apps/Model/retailer_registerModel.dart';
import 'package:now_apps/Reusable/reusable_RowText.dart';
import 'package:now_apps/Reusable/reusable_alertDialog.dart';
import 'package:now_apps/Reusable/reusable_button.dart';
import 'package:now_apps/Theme/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:now_apps/View/products_page.dart';
import 'package:now_apps/View/retailer_form.dart';
import '../Drawer/drawer.dart';
import '../Model/miniProduct.dart';
import '../Services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  void initState() {
    _fetchAndStoreProducts();
    super.initState();
  }

  Future<void> _fetchAndStoreProducts() async {
    try {
      List<ProductModel> products =
          await _databaseService.fetchProductsFromAPI();
      await _databaseService.addProducts(products);
    } catch (e) {
      print("Error fetching and storing products: $e");
    }
  }

  _showCheckOutDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: "Check Out Alert",
        content: "Are you sure you want to exit?",
        cancelText: "Cancel",
        confirmText: "Ok",
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          SystemNavigator.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> SliderIMG = [
      'assets/1.jpg',
      'assets/2.jpg',
      'assets/3.jpg',
      'assets/4.jpg',
      'assets/5.jpg'
    ];
    return Scaffold(
      backgroundColor: AppColor.PurebackgroundColor,
      drawer: const MyNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: AppColor.buttonColor,
        title: Text(
          'AppsNow',
          style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          return _showCheckOutDialog();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            // Slider
            CarouselSlider(
              options: CarouselOptions(
                  height: 180,
                  aspectRatio: 16 / 9,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(seconds: 2),
                  viewportFraction: 0.8),
              items: SliderIMG.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image(
                            image: AssetImage(i),
                            fit: BoxFit.cover,
                          ),
                        ));
                  },
                );
              }).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Registered Retailers',
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 340,
              child: FutureBuilder(
                future: _databaseService.getRetailerRegister(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        RetailerRegister users = snapshot.data![index];
                        return InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Detailed View'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RowText(
                                        content: ' ${users.name}',
                                        title: "Name        ",
                                      ),
                                      RowText(
                                        content: ' ${users.phone}',
                                        title: "Phone       ",
                                      ),
                                      RowText(
                                        content: ' ${users.address}',
                                        title: "Address    ",
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Card(
                            color: AppColor.PurebackgroundColor,
                            elevation: 2,
                            child: ListTile(
                              title: Text(
                                users.name,
                                style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                users.phone,
                                style: GoogleFonts.openSans(fontSize: 15),
                              ),
                              trailing: CustomButton(
                                buttonName: 'Check In',
                                fontSize: 11,
                                width: 70,
                                height: 30,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        "Check in to ${users.name}'s Products?",
                                        style: GoogleFonts.openSans(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                      content: const Text(
                                        "You can only return after clicking the check-out button.",
                                      ),
                                      actions: [
                                        CustomButton(
                                          buttonName: 'Cancle',
                                          width: 60,
                                          height: 30,
                                          startColor:
                                              AppColor.PurebackgroundColor,
                                          endColor: AppColor.backgroundColor,
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                        CustomButton(
                                            buttonName: 'Ok',
                                            width: 60,
                                            height: 30,
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductsPage(
                                                      Checkin: true,
                                                      name: users.name,
                                                      fbCount: 0,
                                                    ),
                                                  ));
                                            }),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Text('No Registered Users');
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: CustomButton(
                  buttonName: 'Register New Retailer',
                  height: 40,
                  width: 300,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RetailerForm(),
                        ));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
