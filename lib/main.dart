import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/auth/role_selection.dart';
import 'package:storeapp/main_screens/customer_home.dart';
import 'package:storeapp/main_screens/welocme.dart';
import 'package:storeapp/providers/cart_provider.dart';
import 'package:storeapp/providers/wish_provider.dart';
import 'Customer_Screen/customer_order.dart';
import 'Customer_Screen/customer_wishlist.dart';
import 'auth/customer_signup.dart';
import 'auth/supplier__signup.dart';
import 'auth/login.dart';
import 'dashboard_components/balance.dart';
import 'dashboard_components/edit_product.dart';
import 'dashboard_components/manage_product.dart';
import 'dashboard_components/my_store.dart';
import 'dashboard_components/orders.dart';
import 'dashboard_components/stati.dart';
import 'main_screens/supplier_home.dart';
import 'firebase_options.dart';
import 'main_screens/upload_product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => Cart()),
    ChangeNotifierProvider(create: (context) => Wish()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/home',
      routes: {
        // '/home': (context) => const ,
        '/home': (context) => const LoginScreen(),
        '/role': (context) => const RoleSelectionScreen(),
        '/CustomerHome': (context) => const CustomerHomeScreen(),
        '/CustomerSignUp': (context) => const CustomerSignUp(),
        '/Customer/Wishlist': (context) => const CustomerWishlist(),
        '/Customer/Orders': (context) => const CustomerOrders(),
        '/SupplierHome': (context) => const SupplierHomeScreen(),
        '/SupplierSignUp': (context) => const SupplierSignUp(),
        '/Balance': (context) => const BalanceScreen(),
        '/MyStore': (context) => const MyStoreScreen(),
        '/EditProduct': (context) => const EditProductScreen(),
        '/ManageProduct': (context) => const ManageProductScreen(),
        '/Statistics': (context) => const StatisticsScreen(),
        '/Orders': (context) => const OrdersScreen(),
        '/UploadProduct': (context) => const UploadProductScreen(),
      },
    );
  }
}
