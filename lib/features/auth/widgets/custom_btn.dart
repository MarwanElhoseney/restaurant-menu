import 'package:flutter/material.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/share/custom_text.dart';

class CustomAuthBtn extends StatelessWidget {
  const CustomAuthBtn({
    super.key,
    this.onTap,
    required this.text,
    this.color,
    this.textColor,
  });

  final Function()? onTap;
  final String text;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        child: Center(
          child: CustomText(
            text: text,
            size: 15,
            weight: FontWeight.w700,
            color: textColor ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}
