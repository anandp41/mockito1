import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUp extends AuthEvent {
  final String email;
  final String password;
  final Map<String, dynamic> data;

  SignUp({required this.email, required this.password, required this.data});

  @override
  List<Object?> get props => [email, password, data];
}

class LogIn extends AuthEvent {
  final String email;
  final String password;
  LogIn({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class CreateProfile extends AuthEvent {
  final String email;
  final String password;
  final Map<String, dynamic> data;
  CreateProfile({required this.email, required this.password, required this.data});
  @override
  List<Object?> get props => [email, password, data];
}
