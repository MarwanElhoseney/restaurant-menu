import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/share/custom_text.dart';

import '../../../core/constants/app_colors.dart';

class SpicySlider extends StatefulWidget {
  const SpicySlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.image,
  });
  final double value;
  final ValueChanged<double> onChanged;
  final String image;

  @override
  State<SpicySlider> createState() => _SpicySliderState();
}

class _SpicySliderState extends State<SpicySlider> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.network(widget.image),
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 3),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
              trackHeight: 3,
            ),

            child: Slider(
              min: 0,
              max: 1,
              value: widget.value,
              onChanged: widget.onChanged,
              inactiveColor: Colors.grey.shade900.withOpacity(0.2),
              activeColor: AppColors.primary.withOpacity(0.7),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 53),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(text: 'Cold 🥶', weight: FontWeight.bold, size: 12),
              Gap(100),
              CustomText(text: '🌶️ Hot', weight: FontWeight.bold, size: 12),
            ],
          ),
        ),
      ],
    );
  }
}