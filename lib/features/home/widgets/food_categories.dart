import 'package:flutter/material.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/share/custom_text.dart';

class FoodCategories extends StatefulWidget {
  FoodCategories({
    super.key,
    required this.selectedIndex,
    required this.category,
  });

  final int selectedIndex;
  final List category;

  @override
  State<FoodCategories> createState() => _FoodCategoriesState();
}

class _FoodCategoriesState extends State<FoodCategories> {
  late int selectedIndex;

  @override
  void initState() {
    // TODO: implement initState
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.category.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },

            child: Container(
              margin: EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color:
                    selectedIndex == index
                        ? AppColors.primary
                        : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 27, vertical: 15),
              child: CustomText(
                text: widget.category[index],
                weight: FontWeight.w600,
                color: selectedIndex == index ? Colors.white : Colors.black,
              ),
            ),
          );
        }),
      ),
    );
  }
}
