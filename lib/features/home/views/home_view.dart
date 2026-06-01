import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/features/home/data/model/product_model.dart';
import 'package:restaurant_app/features/home/data/repo/product_repo.dart';
import 'package:restaurant_app/features/home/widgets/card_item.dart';
import 'package:restaurant_app/features/home/widgets/food_categories.dart';
import 'package:restaurant_app/features/home/widgets/search_field.dart';
import 'package:restaurant_app/features/home/widgets/user_header.dart';
import 'package:restaurant_app/features/product/views/product_details_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List category = ["All", "Combo", "Sliders", "Classic"];
  int selectedIndex = 0;
  List<String> favoriteProducts = [];
  List<ProductModel>?products;
  ProductRepo productRepo = ProductRepo();

  Future<void> getProducts() async {
    final res = await productRepo.getProducts();
    setState(() {
      products = res;
    });
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      favoriteProducts = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> toggleFavorite(String productId) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (favoriteProducts.contains(productId)) {
        favoriteProducts.remove(productId);
      } else {
        favoriteProducts.add(productId);
      }
    });

    await prefs.setStringList('favorites', favoriteProducts);
  }

  @override
  void initState() {
    super.initState();
    getProducts();
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: PopScope(
        canPop: false,

        child: Skeletonizer(
          enabled: products == null,
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
                      childCount: products?.length,
                          (context, index) {
                        final product = products?[index];
                        if (product == null) {
                          return CupertinoActivityIndicator();
                        }
                        return GestureDetector(
                          onTap: () =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) =>
                                          ProductDetailsView(
                                            productImage: product.image,
                                            productId: product.id,
                                            productPrice: product.price,
                                          ))),


                          child: CardItem(
                            image: product.image,
                            text: product.name,
                            desc: product.desc,
                            rate: product.rate,

                            isFavorite: favoriteProducts.contains(product.name),

                            onFavoriteTap: () {
                              toggleFavorite(product.name);
                            },
                          ),
                        );
                      },
          
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

