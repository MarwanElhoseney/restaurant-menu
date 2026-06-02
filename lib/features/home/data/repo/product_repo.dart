import 'package:restaurant_app/core/network/api_service.dart';
import 'package:restaurant_app/features/home/data/model/product_model.dart';
import 'package:restaurant_app/features/home/data/model/topping_model.dart';

class ProductRepo {
  ApiService _apiService = ApiService();

  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await _apiService.get("/products");
      return (response["data"] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<ToppingModel>> getTopping() async {
    try {
      final response = await _apiService.get("/toppings");
      return (response["data"] as List)
          .map((topping) => ToppingModel.fromJson(topping))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<ToppingModel>> getOptions() async {
    try {
      final response = await _apiService.get("/side-options");
      return (response["data"] as List)
          .map((topping) => ToppingModel.fromJson(topping))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<ProductModel>> searchProduct(String name) async {
    try {
      final response = await _apiService.get(
          "/product", params: {"name": name});

      return (response["data"] as List)
          .map((product) => ProductModel.fromJson(product))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
