import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/share/custom_text.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.image,
    required this.text,
    required this.desc,
    this.onAdd,
    this.onMinus,
    this.onRemove,
    required this.number,
  });

  final String image;
  final String text;
  final String desc;
  final Function()? onAdd;
  final Function()? onMinus;
  final Function()? onRemove;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(image),
                CustomText(text: text, weight: FontWeight.bold),
                CustomText(text: desc),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onAdd,
                      child: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(CupertinoIcons.add, color: Colors.white),
                      ),
                    ),
                    Gap(20),
                    CustomText(
                      text: number.toString(),
                      weight: FontWeight.w400,
                      size: 20,
                    ),
                    Gap(20),
                    GestureDetector(
                      onTap: onMinus,
                      child: CircleAvatar(
                        backgroundColor: AppColors.primary,
                        child: Icon(CupertinoIcons.minus, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    width: 130,
                    height: 45,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomText(text: "Remove", color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
