import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:storeapp/main_screens/customer_home.dart';
import 'package:storeapp/minor_screen/visit_store.dart';
import 'package:storeapp/models/product_model.dart';
import 'package:storeapp/providers/cart_provider.dart';
import 'package:storeapp/providers/wish_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.product['maincateg'])
        .where('subcateg', isEqualTo: widget.product['subcateg'])
        .snapshots();
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Swiper(
                        control: const SwiperControl(
                          padding: EdgeInsets.all(10),
                          color: Colors.black,
                          size: 20,
                        ),
                        pagination: const SwiperPagination(),
                        itemCount: widget.product['proimages'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(
                            widget.product['proimages'][index],
                          );
                        },
                      ),
                    ),
                    Positioned(
                        top: 15,
                        left: 15,
                        child: CircleAvatar(
                          backgroundColor: Colors.teal.shade400,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        )),
                    Positioned(
                        top: 15,
                        right: 15,
                        child: CircleAvatar(
                          backgroundColor: Colors.teal.shade400,
                          child: IconButton(
                            icon: const Icon(
                              Icons.share,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.product['proname']}",
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          )),

                      //Price and Fav Icon(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Rs: ${widget.product['price'].toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              )),
                          IconButton(
                            onPressed: context
                                    .watch<Wish>()
                                    .contains(widget.product['proid'])
                                ? () {
                                    context
                                        .read<Wish>()
                                        .removeWithId(widget.product['proid']);
                                  }
                                : () {
                                    context.read<Wish>().addWishItem(
                                          widget.product['proname'],
                                          widget.product['price'],
                                          1,
                                          widget.product['instock'],
                                          widget.product['proimages'],
                                          widget.product['proid'],
                                          widget.product['sid'],
                                        );
                                  },
                            icon: Icon(
                              context
                                      .watch<Wish>()
                                      .contains(widget.product['proid'])
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),

                      //Stock count
                      Text("InStock: ${widget.product['instock']} pieces left",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          )),
                      // Product Description Header
                      const ProductDetailsPageHeading(
                          heading: "  Product Description  "),
                      // Product Description
                      Text(
                        "${widget.product['prodesc']}",
                        textScaleFactor: 1.1,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const ProductDetailsPageHeading(
                          heading: "  Similer Products  "),
                      // Similer Products
                      SizedBox(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: productsStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.data!.docs.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No Products Found\n\n in this Category',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }

                            return StaggeredGridView.countBuilder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              crossAxisCount: 2,
                              itemBuilder: (context, index) => ProductModel(
                                  product: snapshot.data!.docs[index]),
                              staggeredTileBuilder: (context) =>
                                  const StaggeredTile.fit(1),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Store and cart icon button and Add to cart button
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitStoreScreen(
                          supplierId: widget.product['sid'],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.store,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                Badge(
                  showBadge:
                      context.watch<Cart>().getitems.isEmpty ? false : true,
                  badgeContent: Text(
                    context.watch<Cart>().totalcount.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CustomerHomeScreen(
                                    isCart: true,
                                  )));
                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    onPressed:
                        !context.watch<Cart>().contains(widget.product['proid'])
                            ? () {
                                context.read<Cart>().add(
                                      widget.product['proname'],
                                      widget.product['price'],
                                      1,
                                      widget.product['instock'],
                                      widget.product['proimages'],
                                      widget.product['proid'],
                                      widget.product['sid'],
                                    );
                              }
                            : null,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      context.watch<Cart>().contains(widget.product['proid'])
                          ? "Added to Cart"
                          : "Add to Cart",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProductDetailsPageHeading extends StatelessWidget {
  const ProductDetailsPageHeading({
    Key? key,
    required this.heading,
  }) : super(key: key);

  final String heading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const HeadingDividerLine(),
        Text(
          heading,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.amber,
            fontWeight: FontWeight.w800,
          ),
        ),
        const HeadingDividerLine(),
      ],
    );
  }
}

class HeadingDividerLine extends StatelessWidget {
  const HeadingDividerLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.18,
      child: const Divider(
        color: Colors.amber,
        thickness: 2,
      ),
    );
  }
}
