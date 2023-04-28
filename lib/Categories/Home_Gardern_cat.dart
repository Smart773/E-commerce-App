import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:storeapp/minor_screen/subcat_products.dart';

import '../utilities/categ_list.dart';
import '../widgets/cat_widgets.dart';

class HomeAndGardenCategory extends StatefulWidget {
  const HomeAndGardenCategory({super.key});

  @override
  State<HomeAndGardenCategory> createState() => _HomeAndGardenCategoryState();
}

class _HomeAndGardenCategoryState extends State<HomeAndGardenCategory> {
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
                const CatHeaderLabel(headerLable: "Home & Garden"),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,
                      children: List.generate(
                        homeandgarden.length - 1,
                        (index) => SubCatModel(
                            subCatName: homeandgarden[index + 1],
                            mainCatName: "homeandgarden",
                            assetName: 'images/homegarden/home$index.jpg',
                            subCatLable: homeandgarden[index + 1]),
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
