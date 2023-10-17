import 'package:email_validator/email_validator.dart';
import 'package:final_app/constants/constants.dart';
import 'package:final_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../components/rounded_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  static const String id = "registration_screen";

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void registrationFunction() async {
    final email = emailController.text;
    final password = passwordController.text;
    final bool isValidEmail = EmailValidator.validate(email);
    if (isValidEmail && password.length >= 6) {
      try {
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        emailController.clear();
        passwordController.clear();
        Navigator.pushNamed(context, LoginScreen.id);
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.success(
              message: "Registration Sucessful Login now"),
        );
      } catch (e) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(message: e.toString()),
        );
      }
    }
    showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
          message: !isValidEmail
              ? "Please Enter Valid e-mail Address"
              : "Password Must be 6 Character or Longer"),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
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
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: textFieldProperty.copyWith(
                  hintText: "At least 6 characters long",
                  label: const Text("Password"),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            RoundedButton(
              "Register",
              RegistrationScreen.id,
              customOnPressed: registrationFunction,
            ),
          ],
        ),
      ),
    );
  }
}
