import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:mockit/features/auth/data/repository/firestore.dart';
import 'package:mockit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mockit/firebase_options.dart';

final sl = GetIt.instance;

Future<void> init() async {
  var app=  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);//firebase_core init

  var firestore = FirebaseFirestore.instance; //cloud firestore instance
  var auth = FirebaseAuth.instanceFor(app: app);// firebase auth
  sl.registerFactory(() => AuthBloc(authRepository: sl())); // BLoC used in app 
  sl.registerLazySingleton(() => firestore);

  sl.registerLazySingleton(() => AuthRepository(firestore: sl(),auth: auth)); // communication service with Firebase Cloud Firestore
}
