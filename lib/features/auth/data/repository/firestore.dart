import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockit/core/error/failures.dart';
import 'package:mockit/features/auth/data/models/login_data_model.dart';

class AuthRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  AuthRepository({required this.firestore, required this.auth});

  Future<Either<Failure, bool>> checkEmailForDuplicate(String email) async {
    try {
      var user = await firestore
          .collection("users")
          .where("email", whereIn: [email])
          .get();
      if (user.docs.isNotEmpty) {
        return const Left(Failure("Email already in use."));
      }
      return const Right(true);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> registerUser(Map<String, dynamic> data) async {
    try {
      var res = await firestore.collection("users").add(data);
      if (res.id.isNotEmpty) {
        return const Right(true);
      }
      return const Left(Failure("Failed to register user."));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> login(LoginDataModel data) async {
    try {
      var res = await auth.signInWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );
      if (res.user != null) {
        return const Right(true);
      }
      return const Left(Failure("User session creation failed."));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.message ?? "Invalid credentials."));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
