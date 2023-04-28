import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:storeapp/models/product_model.dart';

class VisitStoreScreen extends StatefulWidget {
  final String supplierId;
  const VisitStoreScreen({super.key, required this.supplierId});

  @override
  State<VisitStoreScreen> createState() => _VisitStoreScreenState();
}

class _VisitStoreScreenState extends State<VisitStoreScreen> {
  bool followStatus = false;
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('supplier');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.supplierId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 130,
              flexibleSpace:
                  Image.asset("images/inapp/coverimage.jpg", fit: BoxFit.cover),
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(data['logoImage']),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['storename'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Follow Button

                      data['cid'] == FirebaseAuth.instance.currentUser!.uid
                          ? MaterialButton(
                              onPressed: () {},
                              color: Colors.blue,
                              child: const Text(
                                'Edit Store',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : MaterialButton(
                              onPressed: () {},
                              color: Colors.blue,
                              child: Text(
                                followStatus ? 'Unfollow' : 'Follow',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                    ],
                  ),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('sid', isEqualTo: widget.supplierId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      'No Products Found\n\n in this Store',
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

        return const Material(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
