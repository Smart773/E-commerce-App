import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:storeapp/main_screens/customer_home.dart';
import 'package:storeapp/providers/cart_provider.dart';
import 'package:storeapp/widgets/appbar_widgets.dart';
import 'package:uuid/uuid.dart';

import '../widgets/utils.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late String orderId;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void showProgress() {
    ProgressDialog dialog = ProgressDialog(context: context);

    dialog.show(
      max: 100,
      msg: 'Processing Order',
    );
  }

  @override
  Widget build(BuildContext context) {
    String subtotal = context.watch<Cart>().totalAmount.toStringAsFixed(2);
    String total = (double.parse(subtotal) + 10).toStringAsFixed(2);
    return FutureBuilder(
      future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
              backgroundColor: Colors.grey[200],
              appBar: AppBar(
                title: const AppBarTitle(
                  title: 'Place Order',
                ),
                leading: const AppbarBackButton(),
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              body: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.17,
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleWidget(
                              heading: "Subtotal: ", subtotal: subtotal),
                          const TitleWidget(
                              heading: "Shipping: ", subtotal: "10"),
                          const TitleWidget(heading: "Tax: ", subtotal: "0"),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          TitleWidget(
                            heading: "Total: ",
                            subtotal: total,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.43,
                      width: double.infinity,
                      color: Colors.white,
                      child: Column(
                        children: [
                          RadioListTile(
                            value: 1,
                            groupValue: 1,
                            title: const Text('Cash on Delivery'),
                            onChanged: (value) {},
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          RadioListTile(
                            value: 2,
                            groupValue: 1,
                            title: const Text('Credit/Debit Card',
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            onChanged: (value) {},
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                          RadioListTile(
                            value: 3,
                            groupValue: 1,
                            title: const Text('Jazz Cash',
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  )
                ],
              ),
              bottomSheet: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: double.infinity,
                        color: Colors.white,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Confirm your order ',
                              style: TextStyle(
                                color: Colors.teal,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Your order total price is $total',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                showProgress();
                                for (var item
                                    in context.read<Cart>().getitems) {
                                  CollectionReference orderRef =
                                      FirebaseFirestore.instance
                                          .collection('orders');
                                  orderId = const Uuid().v4();
                                  await orderRef.doc(orderId).set({
                                    "cid": data['cid'],
                                    "custname": data['name'],
                                    "custemail": data['email'],
                                    "custphone": data['phone'],
                                    "custaddress": data['address'],
                                    "custimage": data['profileImage'],
                                    "sid": item.supplierId,
                                    "pid": item.documentId,
                                    "oid": orderId,
                                    "oimage": item.imagesUrl[0],
                                    "oprice": item.price * item.qty,
                                    "oqty": item.qty,
                                    "odate": DateTime.now(),
                                    "orderreview": false,
                                    "deliverystatus": "pending",
                                    "paymentstatus": "cash on delivery",
                                    "deliverydate": "",
                                  }).whenComplete(() async {
                                    await FirebaseFirestore.instance
                                        .runTransaction(
                                      (transaction) async {
                                        DocumentReference<Map<String, dynamic>>
                                            docRef = FirebaseFirestore.instance
                                                .collection("products")
                                                .doc(item.documentId);

                                        DocumentSnapshot snapshot2 =
                                            await transaction.get(docRef);
                                        transaction.update(docRef, {
                                          "instock":
                                              snapshot2['instock'] - item.qty,
                                        });
                                      },
                                    );
                                  }).then((value) {
                                    context.read<Cart>().clear();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CustomerHomeScreen()),
                                        (route) => false);
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(200, 50),
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Confirm'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.teal,
                  child: Center(
                    child: Text(
                      'Place Order  Rs: $total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ));
        }
        return const Material(
            child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    Key? key,
    required this.heading,
    required this.subtotal,
  }) : super(key: key);

  final String heading;
  final String subtotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          heading,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          '$subtotal Rs ',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
