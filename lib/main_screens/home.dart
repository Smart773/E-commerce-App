import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:storeapp/galleries/Bags_gallery.dart';
import 'package:storeapp/galleries/accessories_gallery.dart';
import 'package:storeapp/galleries/beauty.dart';
import 'package:storeapp/galleries/electronic_gallery.dart';
import 'package:storeapp/galleries/homeandgarden_gallery.dart';
import 'package:storeapp/galleries/kids_gallery.dart';
import 'package:storeapp/galleries/men_gallery.dart';
import 'package:storeapp/galleries/shoes_gallery.dart';
import 'package:storeapp/galleries/women_gallery.dart';

import '../minor_screen/search.dart';
import '../widgets/appbar_search_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dummy = "5";
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.teal.shade200.withOpacity(0.2),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const AppbarSearchButton(),
          bottom: const TabBar(
            indicatorWeight: 8,
            isScrollable: true,
            indicatorColor: Colors.teal,
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.grey,
            tabs: [
              RepeatedTabs(lable: 'Men'),
              RepeatedTabs(lable: 'Women'),
              RepeatedTabs(lable: 'Shoes'),
              RepeatedTabs(lable: 'Bags'),
              RepeatedTabs(lable: 'Electronics'),
              RepeatedTabs(lable: 'Accessories'),
              RepeatedTabs(lable: 'Home & Garden'),
              RepeatedTabs(lable: 'Kids'),
              RepeatedTabs(lable: 'Beauty'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MenGalleryScreen(),
            WomenGalleryScreen(),
            ShoesGalleryScreen(),
            BagsGalleryScreen(),
            ElectronicGalleryScreen(),
            AccessoriesGalleryScreen(),
            HomeandGardenGalleryScreen(),
            KidsGalleryScreen(),
            BeautyGalleryScreen(),
          ],
        ),
      ),
    );
  }
}

class RepeatedTabs extends StatelessWidget {
  const RepeatedTabs({
    Key? key,
    required this.lable,
  }) : super(key: key);

  final String lable;

  @override
  Widget build(BuildContext context) {
    return Tab(
      text: lable,
    );
  }
}
