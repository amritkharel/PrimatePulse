import 'package:final_app/components/rounded_button.dart';
import 'package:final_app/constants/constants.dart';
import 'package:final_app/screens/login_screen.dart';
import 'package:final_app/screens/profile_screen.dart';
import 'package:final_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 150.0, 0.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'logo',
                    child: SizedBox(
                      height: 80.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  const Text(
                    "PrimatePulse",
                    style: TextStyle(
                      fontSize: 40.0,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30.0),
              RoundedButton("Login", LoginScreen.id),
              const SizedBox(height: 20.0,),
              RoundedButton("Register", RegistrationScreen.id),
            ],
          ),
        ),
      ),
    );
  }
}
