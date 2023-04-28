import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/providers/product_class.dart';
import 'package:storeapp/providers/wish_provider.dart';

import '../providers/cart_provider.dart';

class WishListModel extends StatelessWidget {
  const WishListModel({
    Key? key,
    required this.wishItem,
  }) : super(key: key);

  final Product wishItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 120,
                child: Image.network(
                  wishItem.imagesUrl[0],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(wishItem.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.grey.shade800,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rs. ${wishItem.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.red),
                          ),
                          Row(
                            children: [
                              context
                                      .watch<Cart>()
                                      .contains(wishItem.documentId)
                                  ? const SizedBox()
                                  : IconButton(
                                      onPressed: () {
                                        context.read<Cart>().add(
                                              wishItem.name,
                                              wishItem.price,
                                              wishItem.qty,
                                              wishItem.qntty,
                                              wishItem.imagesUrl,
                                              wishItem.documentId,
                                              wishItem.supplierId,
                                            );
                                      },
                                      icon: const Icon(
                                        Icons.add_shopping_cart,
                                        color: Colors.black,
                                      ),
                                    ),
                              IconButton(
                                onPressed: () {
                                  context.read<Wish>().remove(wishItem);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
