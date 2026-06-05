import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:restaurant_app/features/auth/data/auth_repo.dart';
import 'package:restaurant_app/features/auth/data/user_model.dart';
import 'package:restaurant_app/features/cart/cubit/cart_cubit.dart';
import 'package:restaurant_app/features/cart/cubit/cart_states.dart';
import 'package:restaurant_app/features/cart/data/cart_model.dart';
import 'package:restaurant_app/features/cart/widgets/cart_item.dart';
import 'package:restaurant_app/features/orders/views/checkout_view.dart';
import 'package:restaurant_app/share/custom_button.dart';
import 'package:restaurant_app/share/custom_text.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {


  bool isGuest = false;
  UserModel?userModel;
  AuthRepo authRepo = AuthRepo();

  Future<void> autoLogin() async {
    final user = await authRepo.autoLogin();
    if (!mounted) return;
    setState(() => isGuest = authRepo.isGuest);
    if (user != null) setState(() => userModel = user);
  }


  @override
  void initState() {
    super.initState();
    autoLogin();
  }


  GetCartResponse? cartResponse;
  late List<int> quantities;

  double getTotalPrice(CartCubit cubit) {
    final cartResponse = cubit.cartResponse;

    if (cartResponse == null) return 0.0;

    double total = 0.0;

    for (int i = 0; i < cartResponse.cartData.items.length; i++) {
      final item = cartResponse.cartData.items[i];
      final price = double.tryParse(item.price) ?? 0.0;

      total += price * cubit.quantities[i];
    }

    return total;
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        final cubit = context.read<CartCubit>();
        final cartResponse = cubit.cartResponse;
        final isCartEmpty = cartResponse == null ||
            cartResponse.cartData.items.isEmpty;
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
          ),

          body: state is GetCartLoading
              ? const Center(child: CupertinoActivityIndicator())
              : ListView.builder(
            padding: const EdgeInsets.only(bottom: 120, top: 10),
            itemCount: cartResponse?.cartData.items.length ?? 0,
            itemBuilder: (context, index) {
              final item = cartResponse!.cartData.items[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CartItem(
                  isLoading: state is RemoveCartLoading &&
                      state.itemId == item.itemId,
                  image: item.image,
                  text: item.name,
                  desc: "Spicy ${item.spicy}",
                  number: cubit.quantities[index],

                  onAdd: () => cubit.onAdd(index),
                  onMinus: () => cubit.onMin(index),

                  onRemove: () => cubit.removeCartItem(item.itemId),
                ),
              );
            },
          ),

          bottomSheet: isGuest || isCartEmpty ? null :
          Container(
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
                      text: "${getTotalPrice(cubit).toStringAsFixed(2)} \$",
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
                              totalPrice: getTotalPrice(cubit).toStringAsFixed(
                                  2),
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },

    );
  }
}

class _EmptyOrdersState extends StatelessWidget {
  const _EmptyOrdersState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.shopping_cart_outlined, size: 54, color: Colors.green),
          Gap(16),
          CustomText(
            text: 'NO ITEMS ADEED YET',
            weight: FontWeight.w600,
            size: 18,
          ),
          Gap(3),
          CustomText(
            text: 'Login to pick your favorite food 🍔.',
            size: 12,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
