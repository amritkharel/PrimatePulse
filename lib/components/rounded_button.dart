import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(this.buttonName, this.routeName, {this.customOnPressed, Key? key}):super(key:key);
  final String buttonName;
  final String routeName;
  final VoidCallback? customOnPressed;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Material(
        elevation: 10.0,
        borderRadius: BorderRadius.circular(20.0),
        color: const Color(0xFF008080),
        child: MaterialButton(
          onPressed: customOnPressed ?? () {
            Navigator.pushNamed(context, routeName);
          },
          minWidth: 200.0,
          height: 40.0,
          child: Text(
            buttonName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    ]);
  }
}
