import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storeapp/main_screens/customer_home.dart';

import '../widgets/utils.dart';

class ProfileScreen extends StatefulWidget {
  final String documentId;
  const ProfileScreen({super.key, required this.documentId});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String title = "Profile";
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: customers.doc(widget.documentId).get(),
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
              backgroundColor: Colors.teal.withOpacity(0.1),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    pinned: true,
                    expandedHeight: 140,
                    flexibleSpace: LayoutBuilder(builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return FlexibleSpaceBar(
                        title: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: constraints.biggest.height <= 120 ? 1 : 0,
                          child: const Text('Account',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ),
                        background: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.teal,
                                Colors.tealAccent,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, left: 35),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: data['profileImage'] == ''
                                      ? const AssetImage(
                                              'images/inapp/guest.jpg')
                                          as ImageProvider
                                      : NetworkImage(data['profileImage']),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  data['name'] == '' ? 'Guest' : data['name'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Order Cart  Wislist Row Card Buttons Box
                        const ProfileUseFullButton(),
                        // Profile Details heading Account Info(),
                        // logo Image(),
                        const LogoImage(),
                        const SectionHeading(title: "Account Info"),
                        AccountInfoCard(
                          email: data['email'] == ''
                              ? "example@gamail.com"
                              : data['email'],
                          phone: data['phone'] == ''
                              ? "+92 000 0000000"
                              : data['phone'],
                          address: data['address'] == ''
                              ? "ABC Street, Lahore, Pakistan"
                              : data['address'],
                        ),
                        const SectionHeading(title: "Account Settings"),
                        // Account Settings Card
                        // Edit profile ,change password logout
                        const AcoountSettings(),
                      ],
                    ),
                  )
                ],
              ));
        }

        return const Center(
            child: CircularProgressIndicator(
          color: Colors.teal,
        ));
      },
    );
  }
}

class LogoImage extends StatelessWidget {
  const LogoImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "images/inapp/logo.jpg",
      height: 200,
      width: 200,
    );
  }
}

class AcoountSettings extends StatelessWidget {
  const AcoountSettings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AccountSettingCards(
            title: "Edit Profile",
            icon: Icons.edit,
            onPressed: () {},
          ),
          AccountSettingCards(
            title: "Change Password",
            icon: Icons.lock,
            onPressed: () {},
          ),
          AccountSettingCards(
            title: "Logout",
            icon: Icons.logout,
            onPressed: () async {
              YNDialog(
                context,
                "Logout",
                "Are you sure you want to logout?",
                () {
                  Navigator.pop(context);
                },
                "No",
                () async {
                  await FirebaseAuth.instance.signOut().then((value) {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/home');
                  });
                },
                "Yes",
              );

              // await FirebaseAuth.instance.signOut();
              // Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}

class AccountSettingCards extends StatelessWidget {
  const AccountSettingCards({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);
  final String title;
  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        child: SizedBox(
          height: 50,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(icon),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountInfoCard extends StatelessWidget {
  String email;
  String phone;
  String address;
  AccountInfoCard(
      {super.key,
      required this.email,
      required this.phone,
      required this.address});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(email),
            ),
            const TitleDivider(),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: Text(phone),
            ),
            const TitleDivider(),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Address'),
              subtitle: Text(address),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleDivider extends StatelessWidget {
  const TitleDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 70, right: 10),
      child: Divider(
        thickness: 1,
        color: Colors.black.withOpacity(0.5),
      ),
    );
  }
}

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ---- divider
        SizedBox(
            width: 50,
            height: 40,
            child: Divider(
              thickness: 2,
              color: Colors.black.withOpacity(0.5),
            )),
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class ProfileUseFullButton extends StatelessWidget {
  const ProfileUseFullButton({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ButtonCards(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CustomerHomeScreen(
                          isCart: true,
                        )));
          },
          icon: Icons.shopping_cart,
          title: "Cart",
        ),
        ButtonCards(
          onPressed: () {
            Navigator.pushNamed(context, '/Customer/Orders');
          },
          icon: Icons.shopping_bag,
          title: "Order",
        ),
        ButtonCards(
          onPressed: () {
            Navigator.pushNamed(context, '/Customer/Wishlist');
          },
          icon: Icons.favorite,
          title: "Wishlist",
        )
      ],
    );
  }
}

class ButtonCards extends StatelessWidget {
  const ButtonCards({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final Function() onPressed;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        child: SizedBox(
          height: 100,
          width: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
