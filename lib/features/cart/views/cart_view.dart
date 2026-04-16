import 'package:flutter/material.dart';
import 'package:restaurant_app/features/cart/widgets/cart_item.dart';
import 'package:restaurant_app/features/checkout/views/checkout_view.dart';
import 'package:restaurant_app/share/custom_button.dart';
import 'package:restaurant_app/share/custom_text.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final int itemCount = 3;
  late List<int> quantities;

  @override
  void initState() {
    quantities = List.generate(itemCount, (_) => 1);
    super.initState();
  }

  void onAdd(int index) {
    setState(() {
      quantities[index]++;
    });
  }

  void onMinus(int index) {
    setState(() {
      if (quantities[index] > 1) {
        quantities[index]--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 120, top: 10),
          itemCount: itemCount,

          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: CartItem(
                image: "assets/test/image 6.png",
                text: "Burger",
                desc: "Burger",
                number: quantities[index],
                onAdd: () {
                  onAdd(index);
                },
                onMinus: () {
                  onMinus(index);
                },
              ),
            );
          },
        ),
      ),

      bottomSheet: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              blurRadius: 20,
              offset: const Offset(0, -0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CustomText(text: "total", size: 16),
                SizedBox(height: 4),
                CustomText(text: "\$ 18.9", size: 20),
              ],
            ),
            CustomButton(
              text: "Checkout",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) {
                      return CheckoutView();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
