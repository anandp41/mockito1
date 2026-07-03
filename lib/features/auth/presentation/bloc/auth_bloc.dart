import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockit/features/auth/data/repository/firestore.dart';
import 'package:mockit/features/auth/presentation/bloc/auth_state.dart';

import '../../data/models/login_data_model.dart';
import 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<SignUp>((event, emit) async {
      emit(SignUpLoading());
      final res = await authRepository.checkEmailForDuplicate(event.email);
      res.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (success) =>
            emit(SignUpSuccess(email: event.email, password: event.password)),
      );
    });

    on<LogIn>((event, emit) async {
      emit(LogInLoading());
      final res = await authRepository.login(
        LoginDataModel(email: event.email, password: event.password),
      );
      res.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (success) => emit(LogInSuccess()),
      );
    });

    on<CreateProfile>((event, emit) async {
      emit(CreateProfileLoading());
      try {
        // Create user in Firebase Auth on the Profile page submit
        final authRes = await authRepository.auth
            .createUserWithEmailAndPassword(
              email: event.email,
              password: event.password,
            );

        if (authRes.user != null) {
          final res = await authRepository.registerUser(event.data);
          res.fold(
            (failure) => emit(AuthFailure(failure.message)),
            (success) => emit(CreateProfileSuccess()),
          );
        } else {
          emit(AuthFailure("Auth user registration failed."));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
