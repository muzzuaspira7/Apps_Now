import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:now_apps/Provider/count_feedback.dart';
import 'package:now_apps/View/otp_screen.dart';
import 'package:now_apps/View/home_screen.dart';
import 'package:now_apps/View/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Provider/checkbox.dart';
import 'firebase_options.dart';
import 'View/products_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? lastScreen = prefs.getString('last_screen');
  String? lastScreenName = prefs.getString('last_screen_name');

  runApp(MyApp(initialScreen: lastScreen, initialScreenName: lastScreenName));
}

class MyApp extends StatelessWidget {
  final String? initialScreen;
  final String? initialScreenName;

  const MyApp({super.key, this.initialScreen, this.initialScreenName});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CountFeedback(),
        ),
        ChangeNotifierProvider(create: (context) => CheckboxStatus())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Now Apps',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: AuthenticationWrapper(
          initialScreen: initialScreen,
          initialScreenName: initialScreenName,
        ),
        routes: {
          '/home_screen': (context) => const HomeScreen(),
          '/signup_screen': (context) => LoginSignUpScreen(),
          '/otp_screen': (context) => OtpScreen(
                email: '',
                name: '',
                isNew: false,
                phone: '',
              ),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final String? initialScreen;
  final String? initialScreenName;

  const AuthenticationWrapper(
      {super.key, this.initialScreen, this.initialScreenName});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return _navigateToInitialScreen(context, initialScreenName);
        } else {
          return LoginSignUpScreen();
        }
      },
    );
  }

  Widget _navigateToInitialScreen(BuildContext context, String? name) {
    if (initialScreen == 'ProductsPage' && name != null) {
      return ProductsPage(name: name, Checkin: true, fbCount: 0);
    } else {
      return const HomeScreen();
    }
  }
}
