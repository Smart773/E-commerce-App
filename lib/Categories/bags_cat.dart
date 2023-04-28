import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:storeapp/minor_screen/subcat_products.dart';

import '../utilities/categ_list.dart';
import '../widgets/cat_widgets.dart';

class BagesCategory extends StatefulWidget {
  const BagesCategory({super.key});

  @override
  State<BagesCategory> createState() => _BagesCategoryState();
}

class _BagesCategoryState extends State<BagesCategory> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.76,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CatHeaderLabel(headerLable: "Bags"),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,
                      children: List.generate(
                        bags.length - 1,
                        (index) => SubCatModel(
                            subCatName: bags[index + 1],
                            mainCatName: "bags",
                            assetName: 'images/bags/bags$index.jpg',
                            subCatLable: bags[index + 1]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SideBar()
      ],
    );
  }
}
