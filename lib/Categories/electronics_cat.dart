import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:storeapp/minor_screen/subcat_products.dart';

import '../utilities/categ_list.dart';
import '../widgets/cat_widgets.dart';

class ElectronicsCategory extends StatefulWidget {
  const ElectronicsCategory({super.key});

  @override
  State<ElectronicsCategory> createState() => _ElectronicsCategoryState();
}

class _ElectronicsCategoryState extends State<ElectronicsCategory> {
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
                const CatHeaderLabel(headerLable: "electronics"),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,
                      children: List.generate(
                        electronics.length - 1,
                        (index) => SubCatModel(
                            subCatName: electronics[index + 1],
                            mainCatName: "electronics",
                            assetName:
                                'images/electronics/electronics$index.jpg',
                            subCatLable: electronics[index + 1]),
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
