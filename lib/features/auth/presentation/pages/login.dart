import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mockit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mockit/features/auth/presentation/bloc/auth_event.dart';
import 'package:mockit/features/auth/presentation/bloc/auth_state.dart';
import 'package:mockit/utils/color_constants.dart';
import 'package:mockit/utils/snackbar_utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(LogIn(email: _emailController.text.trim(),
      password: _passwordController.text.trim() ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LogInSuccess) {
              SnackbarUtils.showSuccess(context, 'Logged in successfully!');
              // Successfully logged in, go to home screen
              context.go('/home');
            } else if (state is AuthFailure) {
              SnackbarUtils.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.textDark,
                            height: 1.2,
                          ),
                          children: [
                            TextSpan(text: 'Welcome\nto '),
                            TextSpan(
                              text: 'TestApp',
                              style: TextStyle(color: ColorConstants.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'All users are verified to help prevent fake accounts.',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorConstants.textLight,
                        ),
                      ),
                      const SizedBox(height: 48),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: ColorConstants.inputBackground,
                          contentPadding: const EdgeInsets.all(18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: ColorConstants.primary, width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: ColorConstants.inputBackground,
                          contentPadding: const EdgeInsets.all(18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: ColorConstants.primary, width: 1.5),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstants.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          onPressed: state is LogInLoading ? null : _submit,
                          child: state is LogInLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Center(
                        child: GestureDetector(
                          onTap: () => context.go('/register'),
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(fontSize: 14, color: ColorConstants.textLight),
                              children: [
                                TextSpan(text: "Don't have account, "),
                                TextSpan(
                                  text: 'Signup',
                                  style: TextStyle(
                                    color: ColorConstants.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }