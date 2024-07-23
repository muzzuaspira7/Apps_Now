import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:now_apps/View/cart_page.dart';
import 'package:now_apps/View/home_screen.dart';
import 'package:now_apps/View/orders_page.dart';
import 'package:now_apps/View/signup_screen.dart';

class MyNavigationDrawer extends StatelessWidget {
  const MyNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[buildHeader(context), buildMenuItems(context)],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        color: Color(0xFFE2E5DE),
        padding: EdgeInsets.only(
          top: 24 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 52,
              backgroundImage:
                  NetworkImage('https://wallpapercave.com/dwp1x/wp5977491.jpg'),
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Arjun Das',
              style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'SecondaryFont',
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            // Text(
            //   FirebaseAuth.instance.currentUser!.uid.toString(),
            //   style: TextStyle(
            //     fontSize: 18,
            //     color: Colors.black,
            //   ),
            // )
          ],
        ),
      );

  Widget buildMenuItems(BuildContext context) => Container(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          runSpacing: 16,
          children: [
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('My Cart'),
              onTap: () {
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => const CartPage()));

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartPage('')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.update_sharp),
              title: const Text('My Order'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const OrderPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginSignUpScreen(),
                    ));
              },
            ),
          ],
        ),
      );
}
