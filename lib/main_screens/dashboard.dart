import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:storeapp/dashboard_components/balance.dart';
import 'package:storeapp/dashboard_components/edit_product.dart';
import 'package:storeapp/dashboard_components/manage_product.dart';
import 'package:storeapp/dashboard_components/orders.dart';
import 'package:storeapp/dashboard_components/stati.dart';
import 'package:storeapp/minor_screen/visit_store.dart';
import 'package:storeapp/widgets/appbar_widgets.dart';
import 'package:storeapp/widgets/utils.dart';

List label = [
  'Store',
  'Orders',
  'Edit\nProducts',
  'Manage\nProducts',
  'Balance',
  'Statistics'
];

List icon = [
  Icons.store,
  Icons.shopping_cart,
  Icons.edit,
  Icons.manage_accounts,
  Icons.account_balance_wallet,
  Icons.analytics
];

List<Widget> route = [
  VisitStoreScreen(supplierId: FirebaseAuth.instance.currentUser!.uid),
  const OrdersScreen(),
  const EditProductScreen(),
  const ManageProductScreen(),
  const BalanceScreen(),
  const StatisticsScreen()
];

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade100.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const AppBarTitle(title: 'Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.black),
              onPressed: () async {
                YNDialog(
                  context,
                  "Logout",
                  "Are you sure you want to logout?",
                  () {
                    Navigator.pop(context);
                  },
                  "No",
                  () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/home');
                    });
                  },
                  "Yes",
                );

                // await FirebaseAuth.instance.signOut();
                // Navigator.pushReplacementNamed(context, '/home');
              },
            ),
          ),
        ],
      ),
      body: GridView.count(
        mainAxisSpacing: 50,
        crossAxisSpacing: 10,
        crossAxisCount: 2,
        children: List.generate(
            6,
            (index) => InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => route[index]));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1.5,
                            blurRadius: 2,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon[index], size: 50, color: Colors.teal),
                          Text(label[index],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }
}
