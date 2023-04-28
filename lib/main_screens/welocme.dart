import 'package:flutter/material.dart';
import 'package:storeapp/main_screens/supplier_home.dart';

class WelcomScreen extends StatefulWidget {
  const WelcomScreen({super.key});

  @override
  State<WelcomScreen> createState() => _WelcomScreenState();
}

class _WelcomScreenState extends State<WelcomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Logo(),
          Image.asset('images/inapp/logo.jpg'),
          // Row to login as Suppler() has button for login and Signup
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black), color: Colors.teal),
            child: Row(children: [
              // Supplier Heading(
              const Text('Wholesaler',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              // Login as Supplier(),
              OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/SupplierLogin');
                },
                child: const Text('Login'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/SupplierSignUp');
                },
                child: const Text('Signup'),
              ),
            ]),
          ),
          // Row to login as Customer(),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black), color: Colors.teal),
            child: Row(children: [
              // Supplier Heading(
              const Text('Retailer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              // Login as Supplier(),
              OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/CustomerLogin');
                },
                child: const Text('Login'),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(foregroundColor: Colors.black),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/CustomerSignUp');
                },
                child: const Text('Signup'),
              ),
            ]),
          ),

          // Row to login With Google() , Facebook() or As Guest(),
        ],
      ),
    );
  }
}
