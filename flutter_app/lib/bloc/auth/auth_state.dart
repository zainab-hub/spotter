part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {
  AuthInitial();
}

final class AuthNotAuth extends AuthState {
  AuthNotAuth();
}

final class AuthSuccess extends AuthState {
  final String uid;
  AuthSuccess(this.uid);
}

final class AuthInProgress extends AuthState {
  AuthInProgress();
}

final class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
