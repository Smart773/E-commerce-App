import 'package:flutter/material.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  State<BalanceScreen> createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Store',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.teal.shade100.withOpacity(0.2),
      body: Container(
        child: const Text('My Store'),
      ),
    );
  }
}
