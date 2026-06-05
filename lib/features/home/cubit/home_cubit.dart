import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/core/network/api_error.dart';
import 'package:restaurant_app/features/cart/data/cart_model.dart';
import 'package:restaurant_app/features/home/cubit/home_states.dart';
import 'package:restaurant_app/features/home/data/model/product_model.dart';
import 'package:restaurant_app/features/home/data/model/topping_model.dart';
import 'package:restaurant_app/features/home/data/repo/home_repo.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitial());

  HomeRepo homeRepo = HomeRepo();
  List<ProductModel> products = [];
  List<ProductModel> allProducts = [];
  List<ToppingModel> toppings = [];
  List<ToppingModel> options = [];

  Future getProducts() async {
    emit(HomeLoading());

    try {
      products = await homeRepo.getProducts();
      allProducts = products;
      emit(HomeSuccess());
    } catch (e) {
      String errorMessage = "something went wrong";
      if (e is ApiError) {
        errorMessage = e.message;
      }
      emit(HomeError(errorMessage));
    }
  }

  void searchProducts(String value) {
    products =
        allProducts.where((products) {
          return products.name.toLowerCase().contains(value.toLowerCase());
        }).toList();

    emit(HomeSuccess());
  }

  Future getToppings() async {
    emit(HomeLoading());

    try {
      toppings = await homeRepo.getTopping();

      emit(HomeSuccess());
    } catch (e) {
      String errorMessage = "something went wrong";
      if (e is ApiError) {
        errorMessage = e.message;
      }
      emit(HomeError(errorMessage));
    }
  }

  Future getOptions() async {
    emit(HomeLoading());

    try {
      options = await homeRepo.getOptions();

      emit(HomeSuccess());
    } catch (e) {
      String errorMessage = "something went wrong";
      if (e is ApiError) {
        errorMessage = e.message;
      }
      emit(HomeError(errorMessage));
    }
  }

  Future addToCart({required CartRequestModel cartModel}) async {
    emit(AddToCartLoading());

    try {
      await homeRepo.addToCart(cartModel);

      emit(AddToCartSuccess());
    } catch (e) {
      String errorMessage = "Failed To Add Product";

      if (e is ApiError) {
        errorMessage = e.message;
      }
      emit(AddToCartError(errorMessage));
    }
  }
}
