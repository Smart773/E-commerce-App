import 'package:flutter/material.dart';
import 'package:storeapp/Categories/Home_Gardern_cat.dart';
import 'package:storeapp/Categories/accessories_cat.dart';
import 'package:storeapp/Categories/bags_cat.dart';
import 'package:storeapp/Categories/beauty_cat.dart';
import 'package:storeapp/Categories/electronics_cat.dart';
import 'package:storeapp/Categories/kids_cat.dart';
import 'package:storeapp/Categories/men_cat.dart';
import 'package:storeapp/Categories/shoes_cat.dart';
import 'package:storeapp/Categories/women_cat.dart';

import '../widgets/appbar_search_button.dart';

List<ItemData> items = [
  ItemData(label: "mens", isSelected: true),
  ItemData(label: "womens"),
  ItemData(label: "shoes"),
  ItemData(label: "bags"),
  ItemData(label: "electronics"),
  ItemData(label: "accessories"),
  ItemData(label: "home & Garden"),
  ItemData(label: "kids"),
  ItemData(label: "beauty"),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    for (var element in items) {
      element.isSelected = false;
    }
    items[0].isSelected = true;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppbarSearchButton(),
      ),
      body: Stack(
        children: [
          Positioned(bottom: 0, left: 0, child: sideNavigator(size: size)),
          Positioned(bottom: 0, right: 0, child: catView(size: size)),
        ],
      ),
    );
  }

  Widget catView({required Size size}) {
    return Container(
        height: size.height * 0.8,
        width: size.width * 0.8,
        color: Colors.teal.shade100.withOpacity(0.2),
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            for (var element in items) {
              element.isSelected = false;
            }
            setState(() {
              items[index].isSelected = true;
              //scroll sideNav to selected item
              _scrollController.animateTo(index * 100.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            });
          },
          scrollDirection: Axis.vertical,
          children: const [
            MenCategory(),
            WomenCategory(),
            ShoesCategory(),
            BagesCategory(),
            ElectronicsCategory(),
            AccessoriesCategory(),
            HomeAndGardenCategory(),
            KidsCategory(),
            BeautyCategory(),
          ],
        ));
  }

  Widget sideNavigator({required Size size}) {
    return SizedBox(
        height: size.height * 0.8,
        width: size.width * 0.2,
        child: ListView.builder(
            controller: _scrollController,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  _pageController.jumpToPage(index);
                },
                child: Container(
                    color: items[index].isSelected ? Colors.teal : Colors.white,
                    height: 100,
                    child: Center(
                        child: Text(items[index].label,
                            style: TextStyle(
                                color: items[index].isSelected
                                    ? Colors.white
                                    : Colors.black)))),
              );
            }));
  }
}

class ItemData {
  String label;
  bool isSelected;
  ItemData({required this.label, this.isSelected = false});
}
