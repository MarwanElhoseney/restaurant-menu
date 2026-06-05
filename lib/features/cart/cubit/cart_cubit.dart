import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/network/api_error.dart';
import 'package:restaurant_app/features/cart/cubit/cart_states.dart';
import 'package:restaurant_app/features/cart/data/cart_model.dart';
import 'package:restaurant_app/features/cart/data/cart_repo.dart';

class CartCubit extends Cubit<CartStates> {
  CartCubit() : super(CartInitial());

  CartRepo cartRepo = CartRepo();

  GetCartResponse? cartResponse;
  List<int> quantities = [];

  Future<void> getCartData() async {
    emit(GetCartLoading());

    try {
      final res = await cartRepo.getCartData();

      cartResponse = res;

      quantities = List.generate(res?.cartData.items.length ?? 0, (_) => 1);

      emit(GetCartSuccess());
    } catch (e) {
      String errorMsg = "Failed To Get Cart";
      if (e is ApiError) {
        errorMsg = e.message;
      }
      emit(GetCartError(errorMsg));
    }
  }

  Future<void> removeCartItem(int itemId) async {
    emit(RemoveCartLoading(itemId));

    try {
      emit(RemoveCartLoading(itemId));

      final index = cartResponse!.cartData.items.indexWhere(
        (item) => item.itemId == itemId,
      );

      if (index == -1) return;

      cartResponse!.cartData.items.removeAt(index);

      if (index < quantities.length) {
        quantities.removeAt(index);
      }

      emit(RemoveCartSuccess());

      await cartRepo.removeCartItem(itemId);
    } catch (e) {
      emit(RemoveCartError(e.toString()));
    }
  }

  void onAdd(int index) {
    quantities[index]++;
    emit(GetCartSuccess());
  }

  void onMin(int index) {
    if (quantities[index] > 1) {
      quantities[index]--;

      emit(GetCartSuccess());
    }
  }
}
