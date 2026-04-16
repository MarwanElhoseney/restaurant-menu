import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/core/constants/app_colors.dart';
import 'package:restaurant_app/features/checkout/widgets/order_details_widget.dart';
import 'package:restaurant_app/share/custom_button.dart';
import 'package:restaurant_app/share/custom_text.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedMethod = "Cash";

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
        padding: const EdgeInsets.symmetric(horizontal: 15),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Order Summary",
                size: 20,
                weight: FontWeight.w500,
              ),
              OrderDetailsWidget(
                order: "10.5",
                taxes: "3.85",
                fees: "40.33",
                total: "100",
              ),
              Gap(80),

              CustomText(
                text: "Payment Method",
                size: 20,
                weight: FontWeight.w500,
              ),
              Gap(15),
              ListTile(
                onTap: () {
                  setState(() {
                    selectedMethod = "Cash";
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                tileColor: Color(0xff3C2F2F),
                leading: Image.asset(
                  "assets/test/dollar Background Removed 1.png",
                  width: 50,
                ),

                title: Text("Cash on Delivery"),
                trailing: Radio<String>(
                  activeColor: Colors.white,
                  value: "Cash",
                  groupValue: selectedMethod,
                  onChanged: (v) {
                    setState(() {
                      selectedMethod = v!;
                    });
                  },
                ),
              ),
              Gap(10),
              ListTile(
                onTap: () {
                  setState(() {
                    selectedMethod = "Visa";
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 16,
                ),
                tileColor: Colors.blue.shade900,
                leading: Image.asset(
                  "assets/test/icons8-visa-80.png",
                  width: 50,
                ),

                title: Text("Debit Card"),
                subtitle: CustomText(
                  text: "**** ***** 2342",
                  color: Colors.white,
                ),
                trailing: Radio<String>(
                  activeColor: Colors.white,
                  value: "Visa",
                  groupValue: selectedMethod,
                  onChanged: (v) {
                    setState(() {
                      selectedMethod = v!;
                    });
                  },
                ),
              ),
              Gap(5),
              Row(
                children: [
                  Checkbox(
                    activeColor: Colors.red,
                    value: true,
                    onChanged: (v) {},
                  ),
                  CustomText(text: "Save card details for future payments"),
                ],
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "total", size: 15),

                  CustomText(text: "\$ 18.9", size: 24),
                ],
              ),
              CustomButton(
                text: "Pay Now",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 200,
                          ),
                          child: Container(
                            width: 300,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade800,
                                  blurRadius: 15,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: (Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: AppColors.primary,
                                  child: Icon(
                                    CupertinoIcons.check_mark,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                Gap(10),
                                CustomText(
                                  text: "success!",
                                  color: AppColors.primary,
                                  size: 20,
                                  weight: FontWeight.bold,
                                ),
                                Gap(3),
                                CustomText(
                                  text:
                                      "Your payment was successful,\n A receipt for this purchase has \n been sent to your email",
                                  color: Colors.grey.shade400,
                                  size: 11,
                                ),
                                Gap(10),

                                CustomButton(
                                  text: "close",
                                  width: 200,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            )),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
