// TODO: LODING at Signup button
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:storeapp/widgets/auth_widgets.dart';
import 'package:storeapp/widgets/utils.dart';
import 'package:image_picker/image_picker.dart';
import "package:firebase_storage/firebase_storage.dart" as firebase_storage;

class CustomerSignUp extends StatefulWidget {
  const CustomerSignUp({super.key});

  @override
  State<CustomerSignUp> createState() => _CustomerSignUpState();
}

class _CustomerSignUpState extends State<CustomerSignUp> {
  String header = "Retalier SignUp Form";
  String haveAccount = "Already have an account?";
  String actionLable = "Login";
  final Function() onPressed = () {};

  bool processing = false;
  late String profileImage;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
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
              .ref('users/${value.user!.uid}/profile.jpg');

          await ref.putFile(File(image!.path)).then(
            (value) async {
              await value.ref.getDownloadURL().then((value) {
                profileImage = value;
                customers
                    .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                    .set({
                  'name': name,
                  'email': email,
                  'profileImage': profileImage,
                  'phone': '',
                  'address': '',
                  'cid': FirebaseAuth.instance.currentUser!.uid.toString(),
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
                  Navigator.pushReplacementNamed(context, '/CustomerLogin');
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
  late String name;
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
                    const AuthHeaderLable(headerLable: "Customer SignUp Form"),
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
                        name = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter your name',
                        labelText: 'Name',
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
                        Navigator.pushReplacementNamed(
                            context, '/CustomerLogin');
                      },
                      actionLable: "Login",
                    ),
                    const AppSpaceH20(),
                    // Big Button to SignUp(),
                    // facebook , google , guest ICon BUtoon Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.facebook),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('G',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 24)),
                        ),
                        processing
                            ? const CircularProgressIndicator()
                            : IconButton(
                                onPressed: () async {
                                  setState(() {
                                    processing = true;
                                  });
                                  await FirebaseAuth.instance
                                      .signInAnonymously()
                                      .then((value) async {
                                    await customers
                                        .doc(FirebaseAuth
                                            .instance.currentUser!.uid
                                            .toString())
                                        .set({
                                      'name': "",
                                      'email': "",
                                      'profileImage': "",
                                      'phone': '',
                                      'address': '',
                                      'cid': FirebaseAuth
                                          .instance.currentUser!.uid
                                          .toString(),
                                    }).then((value) {
                                      Navigator.pushReplacementNamed(
                                          context, '/CustomerHome');
                                    });
                                  });
                                },
                                icon: const Icon(Icons.person),
                              ),
                      ],
                    ),
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

  // BoxDecoration circulerBorder() {
  //   return const BoxDecoration(
  //     border: Border(
  //       top: BorderSide(width: 1.0, color: Colors.black),
  //       left: BorderSide(width: 1.0, color: Colors.black),
  //       right: BorderSide(width: 1.0, color: Colors.black),
  //       bottom: BorderSide(width: 1.0, color: Colors.black),
  //     ),
  //     shape: BoxShape.circle,
  //     image: DecorationImage(
  //       fit: BoxFit.fill,
  //       image:
  //     ),
  //   );
  // }
}
