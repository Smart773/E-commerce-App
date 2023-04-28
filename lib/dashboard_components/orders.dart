import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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
