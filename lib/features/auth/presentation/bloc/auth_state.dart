import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class SignUpLoading extends AuthState {}

class SignUpSuccess extends AuthState {
  final String email;
  final String password;
  SignUpSuccess({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignUpFailure extends AuthState {}

class LogInLoading extends AuthState {}

class LogInFailure extends AuthState {}

class LogInSuccess extends AuthState {}

class CreateProfileLoading extends AuthState {}

class CreateProfileSuccess extends AuthState {}

class CreateProfileFailure extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}
