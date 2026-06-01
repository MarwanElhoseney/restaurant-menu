import 'package:flutter/material.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/share/custom_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.width,
    this.color,
    this.height,
    this.radius,
    this.isLoading = false,
  });

  final String text;
  final Function()? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final double? radius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width,
        height: height ?? 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: color ?? AppColors.primary,
          borderRadius: BorderRadius.circular(radius ?? 10),
        ),
        child: Center(
          child:
              isLoading
                  ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : CustomText(text: text),
        ),
      ),
    );
  }
}