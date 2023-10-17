import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:final_app/constants/constants.dart';
import 'package:final_app/screens/profile_screen.dart';
import 'package:final_app/utils/ProductProvider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../components/rounded_button.dart';
import 'main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static const String id = "login_screen";

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> doesUserProfileExist(
      String collectionName, String documentId) async {
    try {
      final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(documentId)
          .get();
      return documentSnapshot.exists;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void userLogin() async {
    setState(() {
      showSpinner = true;
    });
    final email = emailController.text;
    final password = emailController.text;
    final bool isValidEmail = EmailValidator.validate(email);
    if (isValidEmail) {
      print(isValidEmail);
      try {
        final userCredential = await _auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        final prefs = await SharedPreferences.getInstance();
        final uid = userCredential.user?.uid;
        prefs.setBool('isCartDataFetched', false);
        prefs.setBool('isFavoriteDataFetched', false);
        prefs.setString('userId', uid!);
        prefs.setBool("isLoggedIn", true);
        ref.watch(productProvider.notifier).getProductData();
        emailController.clear();
        passwordController.clear();
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(message: "Login Successful"),
        );
        setState(() {
          showSpinner = false;
        });
        await doesUserProfileExist('userProfile', uid)
            ? Navigator.pushNamed(context, MainScreen.id)
            : Navigator.pushNamed(context, ProfileScreen.id);
      } catch (e) {
        print(e);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(message: "Invalid Login Credentials"),
        );
        setState(() {
          showSpinner = false;
        });
        return;
      }
    }else{
    showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.error(message: "Please Enter Valid e-mail Address"),
    );}
    setState(() {
      showSpinner = false;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: Container(
          decoration: backgroundDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 150.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              //const Text("Input Login Credentials"),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 40.0),
                child: TextField(
                  controller: emailController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: textFieldProperty.copyWith(
                    hintText: "abc@gmail.com",
                    label: const Text("Email Address"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 40.0),
                child: TextField(
                  controller: passwordController,
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: textFieldProperty.copyWith(
                    hintText: "At least 6 characters long",
                    label: const Text("Password"),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              RoundedButton(
                "Login",
                LoginScreen.id,
                customOnPressed: userLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
