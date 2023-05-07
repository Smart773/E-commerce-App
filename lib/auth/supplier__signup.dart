// TODO: LODING at Signup button
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storeapp/widgets/auth_widgets.dart';
import 'package:storeapp/widgets/utils.dart';
import 'package:image_picker/image_picker.dart';
import "package:firebase_storage/firebase_storage.dart" as firebase_storage;

class SupplierSignUp extends StatefulWidget {
  const SupplierSignUp({super.key});

  @override
  State<SupplierSignUp> createState() => _SupplierSignUpState();
}

class _SupplierSignUpState extends State<SupplierSignUp> {
  String header = "WholeSaler SignUp Form";
  String haveAccount = "Already have an account?";
  String actionLable = "Login";
  final Function() onPressed = () {};

  bool processing = false;
  late String logoImage;
  CollectionReference supplier =
      FirebaseFirestore.instance.collection('supplier');
  XFile? image;
  void _pickImageFromGallery() async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image1 = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        if (image1 != null) image = image1;
      });
    } catch (e) {
      print(e);
    }
  }

  void signUp() async {
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select image'),
        ),
      );
    }
    if (_formKey.currentState!.validate() && image != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Processing Data'),
        ),
      );
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((value) async {
          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('users/${value.user!.uid}/storelogo.jpg');

          await ref.putFile(File(image!.path)).then(
            (value) async {
              await value.ref.getDownloadURL().then((value) {
                logoImage = value;
                supplier
                    .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                    .set({
                  'storename': storename,
                  'email': email,
                  'logoImage': logoImage,
                  'role': 'supplier',
                  'phone': '',
                  'cid': FirebaseAuth.instance.currentUser!.uid.toString(),
                  'coverimage': '',
                }).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User Added'),
                    ),
                  );
                  _formKey.currentState!.reset();
                  setState(() {
                    image = null;
                  });
                  Navigator.popUntil(
                      context, (route) => (route.settings.name == '/home'));
                  // Navigator.pushReplacementNamed(context, '/home');
                }).catchError((error) => print("Failed to add user: $error"));
              });
            },
          );
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The password provided is too weak.'),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('The account already exists for that email.'),
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  late String storename;
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
                    const AuthHeaderLable(headerLable: "Supplier SignUp Form"),
                    const AppSpaceH20(),
                    //Circuler Avatar for profile picture
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          image == null ? null : FileImage(File(image!.path)),
                      // backgroundImage:
                    ),
                    // Button to add Image in Circlar Avatar
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black),
                      onPressed: () {
                        _pickImageFromGallery();
                      },
                      child: const Text('Add Image'),
                    ),
                    const AppSpaceH20(),
                    TextFormField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        storename = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your name of store',
                        labelText: 'Store Name',
                      ),
                    ),
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
                    const SizedBox(height: 20),

                    //already have account text and text login Button(),
                    HaveAccount(
                      haveAccount: "Already have account?",
                      onPressed: () {
                        Navigator.popUntil(context,
                            (route) => (route.settings.name == '/home'));
                      },
                      actionLable: "Login",
                    ),
                    const AppSpaceH20(),

                    const AppSpaceH20(),

                    AuthMainButton(
                      onPressed: signUp,
                      mainButtonLabel: "SignUp",
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
