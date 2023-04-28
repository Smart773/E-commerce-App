import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:storeapp/utilities/categ_list.dart';
import 'package:storeapp/widgets/utils.dart';
import "package:firebase_storage/firebase_storage.dart" as firebase_storage;
import 'package:uuid/uuid.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _productName;
  late String _productDescription;
  late double _productPrice;
  late int _productQuantity;
  late String _proId;
  bool _isprocessing = false;
  String _productCategory = "Select Category";
  String _productSubCategory = "SubCategory";
  List<String> _subCatList = [];

  // FileX list
  List<XFile>? _productImages = [];
  List<String>? _listOfimageUrl = [];

  void pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedimgs = await picker.pickMultiImage(
        maxHeight: 500,
        maxWidth: 500,
        imageQuality: 100,
      );
      setState(() {
        if (pickedimgs.isNotEmpty) _productImages = pickedimgs;
      });
    } catch (e) {
      print(e);
    }
  }

  void mainCatFuction(value) {
    setState(() {
      _productCategory = value!;

      if (value == 'Select Category') {
        _subCatList = [];
      } else if (value == 'men') {
        _subCatList = men;
      } else if (value == 'women') {
        _subCatList = women;
      } else if (value == 'electronics') {
        _subCatList = electronics;
      } else if (value == 'accessories') {
        _subCatList = accessories;
      } else if (value == 'shoes') {
        _subCatList = shoes;
      } else if (value == 'home & garden') {
        _subCatList = homeandgarden;
      } else if (value == 'beauty') {
        _subCatList = beauty;
      } else if (value == 'kids') {
        _subCatList = kids;
      } else if (value == 'bags') {
        _subCatList = bags;
      }
      setState(() {
        _productSubCategory = 'SubCategory';
      });
    });
  }

  Widget previewImages() {
    if (_productImages!.isNotEmpty) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _productImages!.length,
        itemBuilder: (context, index) {
          return Image.file(
            File(_productImages![index].path),
            fit: BoxFit.cover,
          );
        },
      );
    }
    return Container(
      height: 100,
      width: 100,
      color: Colors.black,
    );
  }

  Future<void> uploadimgData() async {
    {
      if (_productCategory == 'Select Category') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select category'),
          ),
        );
      } else if (_productSubCategory == 'SubCategory') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select subcategory'),
          ),
        );
      } else if (_productImages!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select image'),
          ),
        );
      } else if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Processing Data')));

        //TODO: upload images to firebase storage
        _isprocessing = true;
        setState(() {});
        for (var img in _productImages!) {
          firebase_storage.Reference ref =
              firebase_storage.FirebaseStorage.instance.ref(
                  'productImages/$_productName/${DateTime.now().toString() + img.name}');
          await ref
              .putFile(
            File(img.path),
          )
              .then((value) async {
            await value.ref.getDownloadURL().then((value) {
              _listOfimageUrl!.add(value);
            });
          });
        }

        //TODO: upload product to firebase firestore

      }
    }
  }

  void uploadprouctData() async {
    if (_listOfimageUrl!.isNotEmpty) {
      CollectionReference productRef =
          FirebaseFirestore.instance.collection('products');
      _proId = const Uuid().v4();
      await productRef.doc(_proId).set({
        'proid': _proId,
        'proname': _productName,
        'prodesc': _productDescription,
        'price': _productPrice,
        'instock': _productQuantity,
        'maincateg': _productCategory,
        'subcateg': _productSubCategory,
        'proimages': _listOfimageUrl,
        'discount': 0,
        'sid': FirebaseAuth.instance.currentUser!.uid,
      }).whenComplete(() {
        _listOfimageUrl = [];
        _productImages = [];
        _productCategory = 'Select Category';
        _productSubCategory = 'SubCategory';
        _subCatList = [];
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product uploaded successfully'),
          ),
        );
        _isprocessing = false;
        setState(() {});
      });
    }
  }

  void uploadproduct() async {
    try {
      FocusScope.of(context).unfocus();
      await uploadimgData().whenComplete(() => uploadprouctData());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // picture box
                    const AppSpaceH20(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          value: _productCategory,
                          items: maincateg
                              .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ))
                              .toList(),
                          onChanged: mainCatFuction,
                        ),
                        DropdownButton<String>(
                          iconDisabledColor: Colors.grey,
                          disabledHint: const Text('SubCategory'),
                          value: _productSubCategory,
                          items: _subCatList
                              .map<DropdownMenuItem<String>>(
                                  (String value) => DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16)),
                                      ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _productSubCategory = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const AppSpaceH20(),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.grey,
                      child: _productImages!.isEmpty
                          ? const Center(
                              child: Text('No Image Selected'),
                            )
                          : previewImages(),
                    ),
                    const AppSpaceH20(),

                    // 2 drop Down
                    // 4 text field
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Product Name';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _productName = newValue!;
                      },
                      maxLength: 100,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Product Name',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Product Description';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _productDescription = newValue!;
                      },
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Product Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const AppSpaceH20(),

                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Product Price';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _productPrice = double.parse(newValue!);
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,4}$')),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Product Price',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const AppSpaceH20(),

                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Product Quantity';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _productQuantity = int.parse(newValue!);
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Product Quantity',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const AppSpaceH20(),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _productImages!.isEmpty
                  ? pickImageFromGallery
                  : () => setState(() {
                        _productImages = [];
                      }),
              child: Icon(_productImages!.isEmpty
                  ? Icons.add_a_photo
                  : Icons.delete_forever),
            ),
            const AppSpaceW20(),
            FloatingActionButton(
              onPressed: _isprocessing ? (() {}) : uploadproduct,
              child: _isprocessing
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Icon(Icons.upload),
            ),
          ],
        ));
  }
}
