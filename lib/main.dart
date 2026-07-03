import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mockit/utils/color_constants.dart';

import 'core/di/di.dart' as di;
import 'core/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (BuildContext context) => di.sl<AuthBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Mockit',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: ColorConstants.primary,
            primary: ColorConstants.primary,
          ),
          scaffoldBackgroundColor: ColorConstants.background,
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
