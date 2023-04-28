
import 'package:flutter/material.dart';
import 'package:storeapp/providers/cart_provider.dart';
import 'package:storeapp/providers/product_class.dart';

class CartModel extends StatelessWidget {
  const CartModel({
    Key? key,
    required this.cartItem,
    required this.cart,
  }) : super(key: key);

  final Product cartItem;
  final Cart cart;

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
                  cartItem.imagesUrl[0],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cartItem.name,
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
                            "Rs. ${cartItem.price.toStringAsFixed(2)}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.red),
                          ),
                          SizedBox(
                            height: 40,
                            child: Card(
                              color: Colors.grey.shade200,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: cartItem.qty == 1
                                        ? () {
                                            cart.remove(cartItem);
                                          }
                                        : () => cart.decrement(cartItem),
                                    icon: Icon(
                                        cartItem.qty == 1
                                            ? Icons.delete_forever
                                            : Icons.remove,
                                        size: 20),
                                  ),
                                  Text(
                                    cartItem.qty.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: cartItem.qty == cartItem.qntty
                                            ? Colors.red
                                            : Colors.black),
                                  ),
                                  IconButton(
                                    onPressed: cartItem.qty == cartItem.qntty
                                        ? null
                                        : () => cart.increment(cartItem),
                                    icon: const Icon(
                                      Icons.add,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
