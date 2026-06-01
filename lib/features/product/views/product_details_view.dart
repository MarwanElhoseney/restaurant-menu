import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/features/cart/data/cart_model.dart';
import 'package:restaurant_app/features/cart/data/cart_repo.dart';
import 'package:restaurant_app/features/home/data/model/topping_model.dart';
import 'package:restaurant_app/features/home/data/repo/product_repo.dart';
import 'package:restaurant_app/features/product/widgets/spicy_slider.dart';
import 'package:restaurant_app/features/product/widgets/topping_card.dart';
import 'package:restaurant_app/share/custom_button.dart';
import 'package:restaurant_app/share/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView(
      {super.key, required this.productImage, required this.productId, required this.productPrice});

  final String productImage;
  final int productId;
  final String productPrice;


  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  double value = .05;
  List<int> selectedToppings = [];
  List<int> selectedOptions = [];


  ProductRepo productRepo = ProductRepo();
  List<ToppingModel>?toppings;
  List<ToppingModel>?options;

  bool isLoading = false;

  Future<void> getToppings() async {
    final res = await productRepo.getTopping();
    setState(() {
      toppings = res;
    });
  }

  Future<void> getOptions() async {
    final res = await productRepo.getOptions();
    setState(() {
      options = res;
    });
  }

  CartRepo cartRepo = CartRepo();

  @override
  void initState() {
    getToppings();
    getOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: widget.productImage.isEmpty,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpicySlider(
                  image: widget.productImage,
                  value: value,
                  onChanged: (v) {
                    setState(() {
                      value = v;
                    });
                  },
                ),
                Gap(50),
                CustomText(text: "Toppings", size: 20),
                Gap(40),
                SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(toppings?.length ?? 4, (index) {
                      final topping = toppings?[index];
                      final id = topping?.id;

                      if (topping == null) {
                        return CupertinoActivityIndicator();
                      }
                      final isSelected = selectedToppings.contains(id);


                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ToppingCard(
                          imageUrl: topping.image,
                          title: topping.name,
                          onAdd: () {
                            setState(() {
                              if (isSelected) {
                                selectedToppings.removeAt(id!);
                              } else {
                                selectedToppings.add(id!);
                              }
                            });
                          },
                        ),
                      );
                    }),
                  ),
                ),
                Gap(20),
                CustomText(text: "Side Options", size: 20),
                Gap(40),
                SingleChildScrollView(
                  clipBehavior: Clip.none,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(options?.length ?? 4, (index) {
                      final option = options?[index];
                      final id = option?.id;

                      if (option == null) {
                        return CupertinoActivityIndicator();
                      }
                      final isSelected = selectedOptions.contains(id);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ToppingCard(
                          imageUrl: option.image,
                          title: option.name,
                          onAdd: () {
                            setState(() {
                              if (isSelected) {
                                selectedOptions.removeAt(id!);
                              } else {
                                selectedOptions.add(id!);
                              }
                            });
                          },
                        ),
                      );
                    }),
                  ),
                ),
                Gap(200),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade800,
                blurRadius: 15,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: "total", size: 15),

                    CustomText(
                        text: "\$ ${widget.productPrice}" ?? "0.0", size: 24),
                  ],
                ),
                CustomButton(text: "Add To Cart",
                    isLoading: isLoading,
                    onTap: () async {
                      try {
                        setState(() => isLoading = true);
                        final cartItem = CartModel(
                          productId: widget.productId,
                          qty: 1,
                          spicy: value,
                          options: selectedOptions,
                          toppings: selectedToppings,
                        );
                        await cartRepo.addToCart(
                            CartRequestModel(items: [cartItem]));
                        setState(() => isLoading = false);

                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(
                                "Added to cart successfully")));
                      } catch (e) {
                        setState(() => isLoading = false);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
