class ApiError {
  final String message;
  final int? statuesCode;

  ApiError({required this.message, this.statuesCode});

  @override
  String toString() {
    return message;
  }
}