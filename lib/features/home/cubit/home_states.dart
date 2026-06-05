abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class HomeSuccess extends HomeStates {}

class HomeError extends HomeStates {
  String message;

  HomeError(this.message);
}

class HomeLoading extends HomeStates {}

class AddToCartLoading extends HomeStates {}

class AddToCartSuccess extends HomeStates {}

class AddToCartError extends HomeStates {
  String message;

  AddToCartError(this.message);
}
