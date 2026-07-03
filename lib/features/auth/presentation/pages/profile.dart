import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mockit/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mockit/features/auth/presentation/bloc/auth_event.dart';
import 'package:mockit/features/auth/presentation/bloc/auth_state.dart';
import 'package:mockit/utils/color_constants.dart';
import 'package:mockit/utils/snackbar_utils.dart';

class ProfilePage extends StatefulWidget {
  final String? email;
  final String? password;
  const ProfilePage({super.key, this.email, this.password});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();

  String? _gender = 'Male';
  String? _nationality = 'Indian';
  final List<String> _selectedLanguages = ['English'];

  final List<String> _nationalities = [
    'Indian',
    'American',
    'British',
    'Canadian',
    'Australian',
  ];
  final List<String> _languages = [
    'English',
    'Hindi',
    'Spanish',
    'French',
    'German',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorConstants.primary,
              onPrimary: Colors.white,
              onSurface: ColorConstants.textDark,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        final day = picked.day.toString().padLeft(2, '0');
        final month = picked.month.toString().padLeft(2, '0');
        final year = picked.year.toString();
        _dobController.text = '$day-$month-$year';
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        CreateProfile(
          email: widget.email ?? '',
          password: widget.password ?? '',
          data: {
            'first_name': _firstNameController.text,
            'last_name': _lastNameController.text,
            'dob': _dobController.text,
            'gender': _gender,
            'email': widget.email,
            'nationality': _nationality,
            'languages': jsonEncode(_selectedLanguages),
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is CreateProfileSuccess) {
            SnackbarUtils.showSuccess(context, 'Profile created successfully!');
            // Successfully saved profile, go to home
            context.go('/home');
          } else if (state is AuthFailure) {
            SnackbarUtils.showError(context, state.message);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/register');
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ColorConstants.inputBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: ColorConstants.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Heading
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
                          TextSpan(text: 'Create your '),
                          TextSpan(
                            text: 'Profile',
                            style: TextStyle(color: ColorConstants.primary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Create your profile with some basic information',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Registered Email Section
                    const Text(
                      "Registered Email",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: widget.email,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: ColorConstants.inputBackground.withAlpha(
                          153,
                        ),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: ColorConstants.textLight,
                          size: 20,
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name Section
                    const Text(
                      "What's your Name",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              filled: true,
                              fillColor: ColorConstants.inputBackground,
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: ColorConstants.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              filled: true,
                              fillColor: ColorConstants.inputBackground,
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: ColorConstants.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'First name is only visible on your profile.',
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.textLight,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // DOB Section
                    const Text(
                      "What's your date of birth",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dobController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        hintText: 'dd-mm-yyyy',
                        filled: true,
                        fillColor: ColorConstants.inputBackground,
                        contentPadding: const EdgeInsets.all(18),
                        suffixIcon: const Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: ColorConstants.textLight,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: ColorConstants.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your date of birth';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Gender Section
                    const Text(
                      "What's your gender",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioGroup(
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                      child: Row(
                        children: [
                          Radio<String>(
                            value: 'Male',
                            activeColor: ColorConstants.primary,
                          ),
                          const Text(
                            'Male',
                            style: TextStyle(
                              fontSize: 15,
                              color: ColorConstants.textDark,
                            ),
                          ),
                          const SizedBox(width: 32),
                          Radio<String>(
                            value: 'Female',
                            activeColor: ColorConstants.primary,
                          ),
                          const Text(
                            'Female',
                            style: TextStyle(
                              fontSize: 15,
                              color: ColorConstants.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Nationality Section
                    const Text(
                      "What's your nationality",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _nationality,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: ColorConstants.inputBackground,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: ColorConstants.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: ColorConstants.textDark,
                      ),
                      items: _nationalities.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: ColorConstants.textDark,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _nationality = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Languages Section
                    const Text(
                      "Languages spoken",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.textDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _languages.map((language) {
                        final isSelected = _selectedLanguages.contains(
                          language,
                        );
                        return FilterChip(
                          label: Text(
                            language,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : ColorConstants.textDark,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: ColorConstants.primary,
                          checkmarkColor: Colors.white,
                          backgroundColor: ColorConstants.inputBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedLanguages.add(language);
                              } else {
                                if (_selectedLanguages.length > 1) {
                                  _selectedLanguages.remove(language);
                                }
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 40),

                    // Save Button
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
                        onPressed: state is CreateProfileLoading
                            ? null
                            : _submit,
                        child: state is CreateProfileLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Save',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
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
