import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:storeapp/models/product_model.dart';
import 'package:storeapp/widgets/appbar_widgets.dart';

class SubCatProducts extends StatefulWidget {
  final String subCatName;
  final String maincatName;
  const SubCatProducts(
      {super.key, required this.subCatName, required this.maincatName});

  @override
  State<SubCatProducts> createState() => _SubCatProductsState();
}

class _SubCatProductsState extends State<SubCatProducts> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productsStream = FirebaseFirestore.instance
        .collection('products')
        .where("maincateg", isEqualTo: widget.maincatName)
        .where("subcateg", isEqualTo: widget.subCatName)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(title: widget.subCatName),
        leading: const AppbarBackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
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
            itemCount: snapshot.data!.docs.length,
            crossAxisCount: 2,
            itemBuilder: (context, index) =>
                ProductModel(product: snapshot.data!.docs[index]),
            staggeredTileBuilder: (context) => const StaggeredTile.fit(1),
          );
        },
      ),
    );
  }
}
