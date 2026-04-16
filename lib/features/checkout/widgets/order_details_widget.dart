import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/share/custom_text.dart';

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({
    super.key,
    required this.order,
    required this.taxes,
    required this.fees,
    required this.total,
  });

  final String order, taxes, fees, total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gap(10),
        checkoutWidget(order, "18.5", false, false),
        Gap(10),

        checkoutWidget(taxes, "3.5", false, false),
        Gap(10),

        checkoutWidget(fees, "2.4", false, false),
        Divider(),
        Gap(10),
        checkoutWidget(total, "100", true, false),
        Gap(10),
        checkoutWidget("Estimated delivery time", "15-30 mins", true, true),
        Gap(10),
      ],
    );
  }
}

Widget checkoutWidget(String title, String price, bool isBold, bool isSmall) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CustomText(
        text: title,
        size: isSmall ? 13 : 15,
        weight: isBold ? FontWeight.bold : FontWeight.w400,
        color: isBold ? Colors.black : Colors.grey.shade600,
      ),
      CustomText(
        text: "$price\$",
        size: isSmall ? 10 : 15,
        weight: isBold ? FontWeight.bold : FontWeight.w400,
        color: isBold ? Colors.black : Colors.grey.shade600,
      ),
    ],
  );
}
