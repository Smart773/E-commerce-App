import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storeapp/minor_screen/product_details.dart';
import 'package:storeapp/providers/wish_provider.dart';

class ProductModel extends StatelessWidget {
  final dynamic product;

  const ProductModel({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: product)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Container(
                  constraints: const BoxConstraints(
                    minHeight: 150,
                    maxHeight: 250,
                  ),
                  child: Image.network(
                    product['proimages'][0],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(product['proname'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Rs:${product['price'].toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            )),
                        product['sid'] == FirebaseAuth.instance.currentUser!.uid
                            ? IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit, color: Colors.red),
                              )
                            : IconButton(
                                onPressed: () {},
                                icon: Icon(
                                    context
                                            .watch<Wish>()
                                            .contains(product['proid'])
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              // Row With Price and Heart Button
            ],
          ),
        ),
      ),
    );
  }
}
