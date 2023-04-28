import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/main_screens/customer_home.dart';
import 'package:storeapp/models/cart_model.dart';
import 'package:storeapp/providers/cart_provider.dart';
import 'package:storeapp/widgets/utils.dart';

import '../minor_screen/place_order.dart';
import '../widgets/appbar_widgets.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal.shade200.withOpacity(0.2),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: 'Cart'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: context.watch<Cart>().getitems.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        YNDialog(
                            context,
                            "Clear Cart",
                            "Are you Sure ?",
                            () {
                              Navigator.pop(context);
                            },
                            "NO",
                            () {
                              Navigator.pop(context);
                              Provider.of<Cart>(context, listen: false).clear();
                            },
                            "YES");
                      },
                      icon: const Icon(Icons.delete, color: Colors.black),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
        body: context.watch<Cart>().getitems.isNotEmpty
            ? const CartWithItems()
            : const EmptyCart(),
        bottomSheet: Container(
          height: 60,
          width: double.infinity,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Total Price in Rs 0.00
              Text(
                  'Total: Rs ${context.watch<Cart>().totalAmount.toStringAsFixed(2)}'),

              ElevatedButton(
                onPressed: context.watch<Cart>().getitems.isNotEmpty
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PlaceOrderScreen()));
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Checkout"),
              ),
            ],
          ),
        ));
  }
}

class CartWithItems extends StatelessWidget {
  const CartWithItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: Consumer<Cart>(
        builder: ((context, cart, child) {
          return ListView.builder(
              itemCount: cart.getitems.length,
              itemBuilder: (context, index) {
                final cartItem = cart.getitems[index];
                return CartModel(cartItem: cartItem, cart: cart);
              });
        }),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text('Your cart is empty'),
          const SizedBox(height: 20),
          //Continue Shoping Button(),
          OutlinedButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CustomerHomeScreen()));
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.teal, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Continue Shopping"),
          ),
        ],
      ),
    );
  }
}
