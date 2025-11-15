import 'package:flutter/material.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/signup_screen.dart';
import '../../domain/user_role.dart';
import 'profile_setup_page.dart';

/// role_selection_page.dart
///
/// This page displays a list of user roles (defined in [UserRole]) that the user
/// can choose from during the onboarding or registration process.
///
/// Once a role is selected, the user is navigated to [SignupScreen] to enter their
/// email and password. The selected role is passed forward through the registration process.
///
/// After successful signup, the user proceeds to [ProfileSetupPage] to complete
/// their profile setup (name, DOB, etc.).
///
/// Related files:
/// - user_role.dart
/// - signup_screen.dart
/// - profile_setup_page.dart

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  final List<UserRole> _availableRoles = const [
    UserRole.guest,
    UserRole.member,
    UserRole.lead,
    UserRole.admin,
    UserRole.superadmin,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Header section
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 32,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Choose Your Role',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This will determine your dashboard and available features',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // roles list
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _availableRoles.length,
                      itemBuilder: (context, index) {
                        final role = _availableRoles[index];
                        return _buildRoleCard(context, role);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, UserRole role) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        child: InkWell(
          onTap: () => _handleRoleSelection(context, role),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _getRoleColor(role).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(role.icon, size: 28, color: _getRoleColor(role)),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.displayName,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getRoleDescription(role),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.guest:
        return Colors.green;
      case UserRole.member:
        return Colors.blue;
      case UserRole.lead:
        return Colors.orange;
      case UserRole.admin:
        return Colors.purple;
      case UserRole.superadmin:
        return Colors.red;
      //default:
      //return Colors.blue;
    }
  }

  String _getRoleDescription(UserRole role) {
    switch (role) {
      case UserRole.guest:
        return 'Limited access to basic features';
      case UserRole.member:
        return 'Standard access to core features';
      case UserRole.lead:
        return 'Team management and oversight';
      case UserRole.admin:
        return 'Full administrative privileges';
      case UserRole.superadmin:
        return 'Complete system control';
      //default:
      //return 'Role description';
    }
  }

  void _handleRoleSelection(BuildContext context, UserRole role) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => SignupScreen(selectedRole: role)),
    );
  }
}
