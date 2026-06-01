import 'package:dio/dio.dart';
import 'package:restaurant_app/core/network/api_error.dart';
import 'package:restaurant_app/core/network/api_exceptions.dart';
import 'package:restaurant_app/core/network/api_service.dart';
import 'package:restaurant_app/core/utils/pref_helper.dart';
import 'package:restaurant_app/features/auth/data/user_model.dart';

class AuthRepo {
  ApiService apiService = ApiService();
  bool isGuest = false;
  UserModel? _currentUser;

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await apiService.post("/login", {
        "email": email,
        "password": password,
      });

      if (response is ApiError) {
        throw response;
      }

      if (response is Map<String, dynamic>) {
        final msg = response["message"];
        final code = response["code"];
        final data = response["data"];

        if (code != 200 && code != 201) {
          throw ApiError(message: msg ?? "Unknown error");
        }

        final user = UserModel.fromJson(data);

        if (user.token != null) {
          await PrefHelper.saveToken(user.token!);
        }

        isGuest = false;
        _currentUser = user;
        return user;
      } else {
        throw ApiError(message: "UnExpected Error From Server");
      }
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel?> signup(String name, String email, String password) async {
    try {
      final response = await apiService.post("/register", {
        "name": name,
        "password": password,
        "email": email,
      });

      if (response is ApiError) {
        throw response;
      }

      if (response is Map<String, dynamic>) {
        final msg = response["message"];
        final code = response["code"];
        final data = response["data"];
        final coder = int.tryParse(code.toString());

        if (coder != 200 && coder != 201) {
          throw ApiError(message: msg ?? "Unknown error");
        }

        final user = UserModel.fromJson(data);

        if (user.token != null) {
          await PrefHelper.saveToken(user.token!);
        }

        isGuest = false;
        _currentUser = user;
        return user;
      } else {
        throw ApiError(message: "UnExpected Error From Server");
      }
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel?> getProfileData() async {
    try {
      final token = await PrefHelper.getToken();

      if (token == null || token == "guest") {
        return null;
      }

      final response = await apiService.get("/profile");
      final user = UserModel.fromJson(response["data"]);

      _currentUser = user;
      return user;
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<UserModel?> updateProfileData({
    required String name,
    required String email,
    required String address,
    String? visa,
    String? imagePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        "name": name,
        "email": email,
        "address": address,
        if (visa != null && visa.isNotEmpty) "Visa": visa,
        if (imagePath != null && imagePath.isNotEmpty)
          "image": await MultipartFile.fromFile(
            imagePath,
            filename: "profile.jpg",
          ),
      });

      final response = await apiService.post("/update-profile", formData);

      if (response is ApiError) {
        throw response;
      }

      if (response is Map<String, dynamic>) {
        final msg = response["message"];
        final code = response["code"];
        final data = response["data"];
        final coder = int.tryParse(code.toString());

        if (coder != 200 && coder != 201) {
          throw ApiError(message: msg ?? "Unknown error");
        }

        final updateUser = UserModel.fromJson(data);
        _currentUser = updateUser;

        return updateUser;
      } else {
        throw ApiError(message: "Invalid Error from Server");
      }
    } on DioError catch (e) {
      throw ApiExceptions.handleError(e);
    } catch (e) {
      throw ApiError(message: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await apiService.post("/logout", {});
    } catch (_) {}

    await PrefHelper.clearToken();
    _currentUser = null;
    isGuest = false;
  }

  Future<void> continueAsGuest() async {
    isGuest = true;
    _currentUser = null;
    await PrefHelper.saveToken("guest");
  }

  Future<UserModel?> autoLogin() async {
    final token = await PrefHelper.getToken();

    if (token == null) {
      isGuest = false;
      _currentUser = null;
      return null;
    }

    // Guest mode
    if (token == "guest") {
      isGuest = true;
      _currentUser = null;
      return null;
    }

    // Logged in user
    isGuest = false;

    try {
      final user = await getProfileData();
      _currentUser = user;
      return user;
    } catch (_) {
      await PrefHelper.clearToken();
      isGuest = false;
      _currentUser = null;
      return null;
    }
  }

  UserModel? get currentUser => _currentUser;

  bool get isLoggedIn => !isGuest && _currentUser != null;
}