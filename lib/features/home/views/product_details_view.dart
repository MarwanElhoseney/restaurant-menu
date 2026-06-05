import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/features/cart/data/cart_model.dart';
import 'package:restaurant_app/features/home/cubit/home_cubit.dart';
import 'package:restaurant_app/features/home/cubit/home_states.dart';
import 'package:restaurant_app/features/home/widgets/spicy_slider.dart';
import 'package:restaurant_app/features/home/widgets/topping_card.dart';
import 'package:restaurant_app/share/custom_button.dart';
import 'package:restaurant_app/share/custom_snack.dart';
import 'package:restaurant_app/share/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({
    super.key,
    required this.productImage,
    required this.productId,
    required this.productPrice,
  });

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

  // List<ToppingModel>? toppings;
  // List<ToppingModel>? options;
  //
  // bool isLoading = false;
  //
  // HomeRepo productRepo = HomeRepo();
  //
  // Future<void> getToppings() async {
  //   final res = await productRepo.getTopping();
  //   setState(() {
  //     toppings = res;
  //   });
  // }
  //
  // Future<void> getOptions() async {
  //   final res = await productRepo.getOptions();
  //   setState(() {
  //     options = res;
  //   });
  // }
  //
  // CartRepo cartRepo = CartRepo();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<HomeCubit>();

    cubit.getToppings();
    cubit.getOptions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is AddToCartSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Added to cart successfully",
              ),
            ),
          );
        }

        if (state is AddToCartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            customSnack(state.message),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

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
                    CustomText(
                      text: "Toppings",
                      size: 20,
                    ),
                    Gap(40),
                    SingleChildScrollView(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          cubit.toppings.length,
                              (index) {
                            final topping = cubit.toppings[index];
                            final id = topping.id;
                            final isSelected =
                            selectedToppings.contains(id);

                            return Padding(
                              padding:
                              const EdgeInsets.only(right: 8.0),
                              child: ToppingCard(
                                imageUrl: topping.image,
                                title: topping.name,
                                onAdd: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedToppings.removeAt(id);
                                    } else {
                                      selectedToppings.add(id);
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Gap(20),
                    CustomText(
                      text: "Side Options",
                      size: 20,
                    ),
                    Gap(40),
                    SingleChildScrollView(
                      clipBehavior: Clip.none,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          cubit.options.length,
                              (index) {
                            final option = cubit.options[index];
                            final id = option.id;
                            final isSelected =
                            selectedOptions.contains(id);

                            return Padding(
                              padding:
                              const EdgeInsets.only(right: 8.0),
                              child: ToppingCard(
                                imageUrl: option.image,
                                title: option.name,
                                onAdd: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedOptions.removeAt(id);
                                    } else {
                                      selectedOptions.add(id);
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
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
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade800,
                    blurRadius: 15,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "total",
                          size: 15,
                          color: Colors.white,
                        ),
                        CustomText(
                          text:
                          "\$ ${widget.productPrice}" ?? "0.0",
                          size: 24,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    CustomButton(

                        widget: state is AddToCartLoading
                            ? CupertinoActivityIndicator(
                          color: AppColors.primary,)
                            : Icon(
                          state is AddToCartSuccess
                              ? CupertinoIcons.check_mark_circled_solid
                              : CupertinoIcons.cart_badge_plus,),
                        gap: 10,
                        height: 40,
                        color: state is AddToCartSuccess
                            ? Colors.grey.shade400
                            : Colors.white,
                        textColor: AppColors.primary,
                        text: state is AddToCartSuccess
                            ? "Added to cart"
                            : "Add To Cart",


                        onTap: state is AddToCartLoading ||
                            state is AddToCartSuccess
                            ? null
                            : () async {
                          cubit.addToCart(cartModel:
                          CartRequestModel(items:
                          [
                            CartModel(
                              productId: widget.productId,
                              qty: 1,
                              spicy: value,
                              options: selectedOptions,
                              toppings: selectedToppings,
                            ),
                          ])
                          );
                        }
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}