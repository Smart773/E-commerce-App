import 'package:flutter/material.dart';
import 'package:storeapp/widgets/appbar_widgets.dart';

class CustomerOrders extends StatefulWidget {
  const CustomerOrders({super.key});

  @override
  State<CustomerOrders> createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Orders'),
        leading: const AppbarBackButton(),
      ),
      body: const Center(child: Text('Orders')),
    );
  }
}
