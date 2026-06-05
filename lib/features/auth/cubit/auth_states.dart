abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthSuccess extends AuthStates {}

class AuthError extends AuthStates {
  String message;

  AuthError(this.message);
}

class AuthLoading extends AuthStates {}