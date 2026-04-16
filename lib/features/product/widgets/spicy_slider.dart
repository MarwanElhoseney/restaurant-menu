import 'package:flutter/material.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/share/custom_text.dart';

class SpicySlider extends StatefulWidget {
  const SpicySlider({super.key, required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  State<SpicySlider> createState() => _SpicySliderState();
}

class _SpicySliderState extends State<SpicySlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset("assets/test/pngwing 12.png", height: 250),
        Spacer(),
        Column(
          children: [
            CustomText(
              text: "Customize Your Burger\n to Your\n Ultimate Experience",
            ),
            Slider(
              min: 0,
              max: 1,
              value: widget.value,
              onChanged: widget.onChanged,
              inactiveColor: Colors.grey.shade300,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ],
    );
  }
}
