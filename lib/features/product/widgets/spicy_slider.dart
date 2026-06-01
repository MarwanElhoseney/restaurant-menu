import 'package:flutter/material.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/share/custom_text.dart';

class SpicySlider extends StatefulWidget {
  const SpicySlider(
      {super.key, required this.value, required this.onChanged, required this.image});

  final double value;
  final ValueChanged<double> onChanged;
  final String image;

  @override
  State<SpicySlider> createState() => _SpicySliderState();
}

class _SpicySliderState extends State<SpicySlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.network(widget.image, height: 250, width: 150,),
        Spacer(),
        Column(
          children: [
            CustomText(
              text: "Customize Your spicy level",
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
