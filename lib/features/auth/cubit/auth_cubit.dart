import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/auth/cubit/auth_states.dart';
import 'package:restaurant_app/features/auth/data/auth_repo.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());
  final AuthRepo authRepo = AuthRepo();

  Future login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      await authRepo.login(email, password);
      emit(AuthSuccess());
    } catch (e) {
      String errorMessage = "something went wrong";

      if (e is AuthError) {
        errorMessage = e.message;
      }
      emit(AuthError(errorMessage));
    }
  }
}