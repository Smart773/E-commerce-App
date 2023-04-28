import 'package:flutter/material.dart';

import '../minor_screen/subcat_products.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        right: 0,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.03,
          child: Container(
            color: Colors.teal[400],
          ),
        ));
  }
}

class SubCatModel extends StatelessWidget {
  const SubCatModel({
    Key? key,
    required this.subCatName,
    required this.mainCatName,
    required this.assetName,
    required this.subCatLable,
  }) : super(key: key);

  final String subCatName;
  final String mainCatName;
  final String assetName;
  final String subCatLable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //move to subcat screen in minor Folder,
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return SubCatProducts(
              subCatName: subCatName, maincatName: mainCatName);
        }));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 65,
              width: 65,
              child: Image(
                image: AssetImage(assetName),
              ),
            ),
            Text(subCatLable,
                style: const TextStyle(
                    fontSize: 9.5, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class CatHeaderLabel extends StatelessWidget {
  const CatHeaderLabel({
    Key? key,
    required this.headerLable,
  }) : super(key: key);

  final String headerLable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(headerLable,
          style: const TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
    );
  }
}
