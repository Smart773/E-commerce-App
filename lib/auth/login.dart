// TODO: LODING at Signup button

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storeapp/widgets/auth_widgets.dart';
import 'package:storeapp/widgets/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool processing = false;

  void logIn() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Processing Data'),
        ),
      );
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login Successful'),
            ),
          );
          CollectionReference supplier =
              FirebaseFirestore.instance.collection('supplier');
          CollectionReference customer =
              FirebaseFirestore.instance.collection('customers');

          supplier
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              Navigator.pushReplacementNamed(context, '/SupplierHome');
            }
          });

          customer
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              Navigator.pushReplacementNamed(context, '/CustomerHome');
            }
          });
        });
      } on FirebaseAuthException catch (e) {
        {
          if (e.code == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No user found for that email.'),
              ),
            );
          } else if (e.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Wrong password provided for that user.'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Something went wrong'),
              ),
            );
          }
        }
      }
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    //Logo
                    Image.asset(
                      'images/inapp/logo.png',
                      height: 200,
                      width: 200,
                    ),
                    const AuthHeaderLable(headerLable: "LogIn Form"),
                    const AppSpaceH20(),
                    //Circuler Avatar for profile picture

                    const AppSpaceH20(),
                    TextFormField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } // is valid email
                        else if (!value.isValidEmail()) {
                          return 'Please enter valid email';
                        }

                        return null;
                      },
                      onChanged: (value) {
                        email = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText: !passwordVisible,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          hintText: 'Enter your password',
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          )),
                    ),
                    // Forget Password Button
                    const AppSpaceH20(),
                    TextButton(
                        onPressed: () {},
                        child: const Text("Forget Password?")),
                    //already have account text and text login Button(),
                    HaveAccount(
                      haveAccount: "Don't have an account? ",
                      onPressed: () {
                        Navigator.pushNamed(context, "/role");
                      },
                      actionLable: "SignUp",
                    ),
                    const AppSpaceH20(),
                    const AppSpaceH20(),

                    AuthMainButton(
                      onPressed: logIn,
                      mainButtonLabel: "Login",
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
