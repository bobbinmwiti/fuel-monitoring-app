part of 'auth_bloc.dart';

abstract class AuthState {
  final UserModel? user;
  
  const AuthState({this.user});
}

class AuthInitial extends AuthState {
  const AuthInitial() : super(user: null);
}

class AuthLoading extends AuthState {
  const AuthLoading() : super();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required UserModel user}) : super(user: user);
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message) : super();
}