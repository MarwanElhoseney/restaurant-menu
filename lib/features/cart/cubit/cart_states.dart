abstract class CartStates {}

class CartInitial extends CartStates {}

class GetCartLoading extends CartStates {}

class GetCartSuccess extends CartStates {}

class GetCartError extends CartStates {
  final String message;

  GetCartError(this.message);
}

class RemoveCartLoading extends CartStates {
  final int itemId;

  RemoveCartLoading(this.itemId);
}

class RemoveCartSuccess extends CartStates {}

class RemoveCartError extends CartStates {
  final String message;

  RemoveCartError(this.message);
}
