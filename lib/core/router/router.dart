import 'package:go_router/go_router.dart';
import 'package:mockit/features/auth/presentation/pages/login.dart';
import 'package:mockit/features/auth/presentation/pages/profile.dart';
import 'package:mockit/features/auth/presentation/pages/register.dart';
import 'package:mockit/features/auth/presentation/pages/home.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/register',
      builder: (context, state) => const Registerpage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) {
        final email = state.uri.queryParameters['email'];
        final password = state.uri.queryParameters['password'];
        return ProfilePage(email: email, password: password);
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
