import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mockit/core/di/di.dart';
import 'package:mockit/features/auth/data/repository/firestore.dart';
import 'package:mockit/utils/color_constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthRepository _authRepository;
  Future<Map<String, dynamic>?>? _profileFuture;

  @override
  void initState() {
    super.initState();
    _authRepository = sl<AuthRepository>();
    _profileFuture = _fetchUserProfile();
  }

  Future<Map<String, dynamic>?> _fetchUserProfile() async {
    final user = _authRepository.auth.currentUser;
    if (user == null) return null;

    final query = await _authRepository.firestore
        .collection('users')
        .where('email', isEqualTo: user.email)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    }
    return null;
  }

  Future<void> _logout() async {
    await _authRepository.auth.signOut();
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authRepository.auth.currentUser;

    return Scaffold(
      backgroundColor: ColorConstants.background,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: ColorConstants.textDark,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: ColorConstants.textDark),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: ColorConstants.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading profile: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final data = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Welcome Home,',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.textDark,
                  ),
                ),
                Text(
                  data?['first_name'] != null
                      ? '${data!['first_name']} ${data['last_name'] ?? ''}'
                      : user?.email ?? 'User',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.primary,
                  ),
                ),
                const SizedBox(height: 32),

                // Profile Details Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.textDark,
                          ),
                        ),
                        const Divider(height: 24, thickness: 1),

                        _buildProfileField(
                          icon: Icons.email_outlined,
                          label: 'Email Address',
                          value:
                              data?['email'] ?? user?.email ?? 'Not provided',
                        ),
                        _buildProfileField(
                          icon: Icons.cake_outlined,
                          label: 'Date of Birth',
                          value: data?['dob'] ?? 'Not provided',
                        ),
                        _buildProfileField(
                          icon: Icons.face_outlined,
                          label: 'Gender',
                          value: data?['gender'] ?? 'Not provided',
                        ),
                        _buildProfileField(
                          icon: Icons.flag_outlined,
                          label: 'Nationality',
                          value: data?['nationality'] ?? 'Not provided',
                        ),

                        const SizedBox(height: 16),
                        const Text(
                          'Languages Spoken',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.textLight,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Languages list as Chips
                        if (data?['languages'] != null)
                          Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children:
                                (data!['languages'] is List
                                        ? List<String>.from(data['languages'])
                                        : [data['languages'].toString()])
                                    .map(
                                      (lang) => Chip(
                                        label: Text(
                                          lang,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        backgroundColor: ColorConstants.primary,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          )
                        else
                          const Text(
                            'None specified',
                            style: TextStyle(
                              fontSize: 15,
                              color: ColorConstants.textDark,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileField({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ColorConstants.primary, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: ColorConstants.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
