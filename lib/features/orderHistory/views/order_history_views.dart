import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/share/custom_button.dart';
import 'package:restaurant_app/share/custom_text.dart';

class OrderHistoryViews extends StatelessWidget {
  const OrderHistoryViews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 120, top: 10),
          itemCount: 3,

          itemBuilder: (context, index) {
            return Card(
              color: Colors.white,

              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/test/image 6.png"),

                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: "Burger",
                                weight: FontWeight.bold,
                              ),
                              CustomText(text: "qty : x2"),
                              CustomText(
                                text: "price : 20\$",
                                weight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(20),
                    CustomButton(
                      text: "Order Again",
                      width: double.infinity,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
