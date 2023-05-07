import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // image Logo(),
          Container(
            width: double.infinity,
          ),
          Image.asset(
            'images/inapp/logo.png',
            height: 200,
            width: 200,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Sign UP as',
            style: TextStyle(fontSize: 20),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/SupplierSignUp');
            },
            child: const Text('Supplier'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/CustomerSignUp');
            },
            child: const Text('Customer'),
          ),
        ],
      ),
    );
  }
}
