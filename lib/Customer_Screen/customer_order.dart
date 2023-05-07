import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storeapp/widgets/appbar_widgets.dart';
import 'package:storeapp/widgets/utils.dart';

class CustomerOrders extends StatefulWidget {
  const CustomerOrders({super.key});

  @override
  State<CustomerOrders> createState() => _CustomerOrdersState();
}

class _CustomerOrdersState extends State<CustomerOrders> {
  String d1 = "";
  String d2 = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Orders'),
        leading: const AppbarBackButton(),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where("cid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
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

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final order = snapshot.data!.docs[index];
              return Card(
                elevation: 3,
                surfaceTintColor: Colors.teal.shade100.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  title: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 80,
                      maxHeight: 80,
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 80,
                              maxHeight: 80,
                              minHeight: 80,
                              minWidth: 80,
                            ),
                            child: Image.network(
                              order['oimage'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                "${order['oname']}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rs: ${order['oprice'].toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "x${order['oqty']}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Read more... ',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Status: ${order['deliverystatus']}',
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade100.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 120,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RepeatedText(
                                heading: "Name", data: "${order['custname']}"),
                            RepeatedText(
                                heading: "Phone",
                                data: "${order['custphone']}"),
                            RepeatedText(
                                heading: "Address",
                                data: "${order['custaddress']}"),
                            RepeatedText(
                                heading: "Email",
                                data: "${order['custemail']}"),
                            RepeatedText(
                                heading: "Delivery Status",
                                data: "${order['deliverystatus']}"),
                            RepeatedText(
                                heading: "Payment Status",
                                data: "${order['paymentstatus']}"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class RepeatedText extends StatelessWidget {
  const RepeatedText({
    Key? key,
    required this.heading,
    required this.data,
  }) : super(key: key);

  final String heading;
  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${heading}:  ${data}",
      style: const TextStyle(
        fontSize: 12.5,
      ),
    );
  }
}
