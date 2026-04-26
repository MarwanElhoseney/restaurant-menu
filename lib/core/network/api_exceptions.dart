import 'package:dio/dio.dart';
import 'package:restaurant_app/core/network/api_error.dart';

class ApiExceptions {
  static ApiError handleError(DioError error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;

    if (statusCode != null) {
      if (data is Map<String, dynamic> && data["message"] != null) {
        return ApiError(message: data["message"], statuesCode: statusCode);
      }
    }
    if (statusCode == 302) {
      throw ApiError(message: "This Email Already Taken ");
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(message: "Bad Connection");
      case DioExceptionType.sendTimeout:
        return ApiError(message: "Request timeout,please try again");
      case DioExceptionType.receiveTimeout:
        return ApiError(message: "Response timeout,please try again");
      default:
        return ApiError(message: "some thing went wrong,please try again");
    }
  }
}