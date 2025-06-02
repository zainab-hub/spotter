part of 'auth_bloc.dart';

sealed class AuthEvent {}

final class AuthLogin extends AuthEvent {
  final String password;
  final String email;

  AuthLogin({required this.password, required this.email});
}

final class AuthLogout extends AuthEvent {}

final class AuthSubscribe extends AuthEvent {}

final class AuthRegister extends AuthEvent {
  final String password;
  final String email;
  final String name;

  AuthRegister(
      {required this.password, required this.email, required this.name});
}