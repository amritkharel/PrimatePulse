import 'package:final_app/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:final_app/screens/home_screen.dart';
import 'package:final_app/screens/home_screen_test.dart';
import 'package:final_app/screens/login_screen.dart';
import 'package:final_app/screens/main_screen.dart';
import 'package:final_app/screens/profile.dart';
import 'package:final_app/screens/profile_screen.dart';
import 'package:final_app/screens/registration_screen.dart';
import 'package:final_app/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool("isLoggedIn");


  runApp(ProviderScope(
    child: Builder(
      builder: (context) {
        return FinalApp(isLoggedIn: isLoggedIn, appContext: context);
      }
    ),
  ));
}

class FinalApp extends StatelessWidget {
  const FinalApp({Key? key, required this.isLoggedIn, required this.appContext})
      : super(key: key);

  final bool? isLoggedIn;
  final BuildContext appContext;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn == true ? MainScreen.id : WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        ProfileViewScreen.id: (context) => const ProfileViewScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        MainScreen.id: (context) => const MainScreen(),
        HomeScreenTest.id: (context) => const HomeScreenTest(isFavoriteView: false,),
        CartScreen.id: (context) => const CartScreen(),
      },
    );
  }
}

