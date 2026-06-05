import 'package:restaurant_app/core/network/api_error.dart';
import 'package:restaurant_app/core/network/api_service.dart';
import 'package:restaurant_app/features/cart/data/cart_model.dart';

class CartRepo {
  final ApiService _apiService = ApiService();


  Future<GetCartResponse?> getCartData() async {
    try {
      final res = await _apiService.get("/cart");

      if (res is ApiError) {
        throw ApiError(message: res.message);
      }
      return GetCartResponse.fromJson(res);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<void> removeCartItem(int id) async {
    try {
      final res = await _apiService.delete("/cart/remove/$id", {});

      if (res["code"] != 200) {
        throw ApiError(message: res["message"] ?? "Something went wrong");
      }
    } catch (e) {
      throw ApiError(message: "Remove Item From Cart: ${e.toString()}");
    }
  }
}
