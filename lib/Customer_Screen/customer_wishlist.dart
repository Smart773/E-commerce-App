import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/models/wish_model.dart';
import 'package:storeapp/providers/wish_provider.dart';
import 'package:storeapp/widgets/utils.dart';

import '../widgets/appbar_widgets.dart';

class CustomerWishlist extends StatefulWidget {
  const CustomerWishlist({super.key});

  @override
  State<CustomerWishlist> createState() => _CustomerWishlistState();
}

class _CustomerWishlistState extends State<CustomerWishlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'WishList'),
        leading: const AppbarBackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: context.watch<Wish>().getWishitems.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      YNDialog(
                          context,
                          "Clear WishList",
                          "Are you Sure ?",
                          () {
                            Navigator.pop(context);
                          },
                          "NO",
                          () {
                            Navigator.pop(context);
                            Provider.of<Wish>(context, listen: false).clear();
                          },
                          "YES");
                    },
                    icon: const Icon(Icons.delete, color: Colors.black),
                  )
                : const SizedBox(),
          ),
        ],
      ),
      body: context.watch<Wish>().getWishitems.isNotEmpty
          ? const WishWithItems()
          : const EmptyWish(),
    );
  }
}

class WishWithItems extends StatelessWidget {
  const WishWithItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: Consumer<Wish>(
        builder: ((context, wish, child) {
          return ListView.builder(
              itemCount: wish.getWishitems.length,
              itemBuilder: (context, index) {
                final wishItem = wish.getWishitems[index];
                return WishListModel(wishItem: wishItem);
              });
        }),
      ),
    );
  }
}

class EmptyWish extends StatelessWidget {
  const EmptyWish({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Your WishList is empty',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
