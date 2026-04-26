import 'package:flutter/material.dart';
import 'package:restaurant_app/features/home/widgets/card_item.dart';
import 'package:restaurant_app/features/home/widgets/food_categories.dart';
import 'package:restaurant_app/features/home/widgets/search_field.dart';
import 'package:restaurant_app/features/home/widgets/user_header.dart';
import 'package:restaurant_app/features/product/views/product_details_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List category = ["All", "Combo", "Sliders", "Classic"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0,
                pinned: true,
                floating: false,
                scrolledUnderElevation: 0,
                backgroundColor: Colors.white,
                toolbarHeight: 160,
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: EdgeInsets.only(top: 38, right: 20, left: 20),
                  child: Column(children: [UserHeader(), SearchField()]),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: FoodCategories(
                    selectedIndex: selectedIndex,
                    category: category,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .73,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    childCount: 6,
                    (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) {
                              return ProductDetailsView();
                            },
                          ),
                        );
                      },
                      child: CardItem(
                        image: "assets/test/image 6.png",
                        text: "cheeseburger",
                        desc: "wendy's burger",
                        rate: "4.9",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
