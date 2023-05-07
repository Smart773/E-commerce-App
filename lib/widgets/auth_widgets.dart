import 'package:flutter/material.dart';

class AuthMainButton extends StatelessWidget {
  const AuthMainButton({
    Key? key,
    required this.onPressed,
    required this.mainButtonLabel,
  }) : super(key: key);

  final Function() onPressed;
  final String mainButtonLabel;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
        maximumSize: Size(200, 50),
        minimumSize: Size(200, 50),
      ),
      onPressed: onPressed,
      child: Text(mainButtonLabel),
    );
  }
}

class HaveAccount extends StatelessWidget {
  const HaveAccount({
    Key? key,
    required this.haveAccount,
    required this.onPressed,
    required this.actionLable,
  }) : super(key: key);

  final String haveAccount;
  final Function() onPressed;
  final String actionLable;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(haveAccount),
        OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
          onPressed: onPressed,
          child: Text(actionLable),
        ),
      ],
    );
  }
}

class AuthHeaderLable extends StatelessWidget {
  const AuthHeaderLable({
    Key? key,
    required this.headerLable,
  }) : super(key: key);

  final String headerLable;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(headerLable,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this);
  }
}
