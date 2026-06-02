import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/features/cart/data/cart_model.dart';
import 'package:restaurant_app/features/cart/data/cart_repo.dart';
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
  GetCartResponse? cartResponse;
  CartRepo cartRepo = CartRepo();

  bool isLoading = false;
  int? removingItemId;

  late List<int> quantities;

  @override
  void initState() {
    super.initState();
    getCartData();
  }

  Future<void> getCartData() async {
    try {
      setState(() => isLoading = true);

      final res = await cartRepo.getCartData();

      if (!mounted) return;

      final itemCount = res?.cartData.items.length ?? 0;

      setState(() {
        cartResponse = res;

        quantities = List.generate(itemCount, (_) => 1);

        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print(e.toString());
    }
  }

  Future<void> removeCartItem(int id) async {
    try {
      setState(() => removingItemId = id);

      await cartRepo.removeCartItem(id);

      final res = await cartRepo.getCartData();

      if (!mounted) return;

      setState(() {
        cartResponse = res;

        quantities = List.generate(
          res?.cartData.items.length ?? 0,
              (_) => 1,
        );

        removingItemId = null;
      });
    } catch (e) {
      setState(() => removingItemId = null);
      print(e.toString());
    }
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

  double getTotalPrice() {
    if (cartResponse == null) return 0.0;

    double total = 0.0;

    for (int i = 0; i < cartResponse!.cartData.items.length; i++) {
      final item = cartResponse!.cartData.items[i];

      final price = double.tryParse(item.price) ?? 0.0;
      final qty = quantities[i];

      total += price * qty;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),

      body: isLoading
          ? const Center(child: CupertinoActivityIndicator())
          : ListView.builder(
        padding: const EdgeInsets.only(bottom: 120, top: 10),
        itemCount: cartResponse?.cartData.items.length ?? 0,
        itemBuilder: (context, index) {
          final item = cartResponse!.cartData.items[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CartItem(
              isLoading: removingItemId == item.itemId,
              image: item.image,
              text: item.name,
              desc: "Spicy ${item.spicy}",
              number: quantities[index],

              onAdd: () => onAdd(index),
              onMinus: () => onMinus(index),

              onRemove: () => removeCartItem(item.itemId),
            ),
          );
        },
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              blurRadius: 20,
              offset: const Offset(0, -2),
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "total price",
                  weight: FontWeight.bold,
                  size: 16,
                ),
                CustomText(
                  text: "${getTotalPrice().toStringAsFixed(2)} \$",
                  size: 16,
                ),
              ],
            ),

            CustomButton(
              text: "Checkout",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CheckoutView(
                          totalPrice: getTotalPrice().toStringAsFixed(2),
                        ),
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
