import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/features/product/widgets/spicy_slider.dart';
import 'package:restaurant_app/features/product/widgets/topping_card.dart';
import 'package:restaurant_app/share/custom_button.dart';
import 'package:restaurant_app/share/custom_text.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  double value = .05;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ToppingCard(
                        imageUrl: "assets/test/pngwing 15.png",
                        title: "tomato",
                        onAdd: () {},
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
                  children: List.generate(4, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ToppingCard(
                        imageUrl: "assets/test/pngwing 15.png",
                        title: "tomato",
                        onAdd: () {},
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

                  CustomText(text: "\$ 18.9", size: 24),
                ],
              ),
              CustomButton(text: "Add To Cart", onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
