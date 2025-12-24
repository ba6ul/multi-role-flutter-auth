import 'package:flutter/material.dart';
import 'package:multi_role_flutter_auth/features/auth/data/UserProfileService.dart'
    as user_profile_service;
import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/signup_screen.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/widgets/auth_field.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/role_selection_page.dart';
import 'package:multi_role_flutter_auth/utils/constants/color.dart';
import 'package:multi_role_flutter_auth/utils/constants/sizes.dart';
import 'package:multi_role_flutter_auth/utils/validators/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../router/dashboard_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  // The user role selection page will be hidden
  static const bool useRoleSelection = false;

  // This gives a default role if the role section is dsabled
  static const UserRole defaultRole = UserRole.admin;

  // For easy customization:
  //static const Color primaryColor = Colors.pink;
  //static const String appName = "Your App Name";
  static const String subTitle = "Let's get Started";
  static const String Title = "Welcome Back";
  static const IconData appIcon = Icons.login_rounded;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final AuthResponse response = await Supabase.instance.client.auth
          .signInWithPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      if (response.user != null) {
        final userId = response.user!.id;

        // Use your service correctly (instance, not static)
        final authService = user_profile_service.AuthService();
        final userRole = await authService.fetchUserRole(userId);

        // Navigate based on the user role
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => DashboardRouter(role: userRole)),
          );
        }
      }
    } on user_profile_service.AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: HSizes.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: HColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // App branding section (customizable)
                        _buildAppBranding(context),

                        const SizedBox(height: 32),

                        // Email Field
                        AuthField(
                          hintText: 'Email address',
                          labelText: 'Email',
                          prefixIcon: Icons.alternate_email_rounded,
                          controller: _emailController,
                          keyboardType:
                              TextInputType.emailAddress, // Added for better UX
                          validator: HValidator.validateEmail,
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        AuthField(
                          hintText: 'Enter Your Password',
                          labelText: "Password",
                          prefixIcon: Icons.lock,
                          controller: _passwordController,
                          obscureText: true,
                          validator: HValidator
                              .validatePassword,
                          onFieldSubmitted: (_) => _login(),
                        ),

                        const SizedBox(height: 24),

                        // Error Message
                        if (_errorMessage != null) ...[
                          _buildErrorMessage(),
                          const SizedBox(height: 16),
                        ],

                        // Login Button
                        _buildLoginButton(context),

                        const SizedBox(height: 24),

                        // Divider with "or" text
                        _buildDivider(),

                        const SizedBox(height: 24),

                        // Sign up section
                        _buildSignupSection(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // App branding section
  Widget _buildAppBranding(BuildContext context) {
    return Column(
      children: [
        // Big title text (to use icon ucomment const Text)
        const Text(
          LoginScreen.Title,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: HColors.primary,
          ),
        ),

        /*
      const Icon(
        Icons.login_rounded, // You can replace this with your logo or another icon
        size: 32,
        color: Colors.blue,
      ),
      */
        const SizedBox(height: 16),

        // Subtitle message
        Text(
          LoginScreen.subTitle,
          style: const TextStyle(
            fontSize: 15,
            color: HColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Reusable error message widget
  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: HColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: HColors.error.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: HColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Customizable login button
  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Sign In',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }

  // Reusable divider
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  // Customizable signup section
  Widget _buildSignupSection(BuildContext context) {
    return Column(
      children: [
        // Create account button
        SizedBox(
          height: 50,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isLoading
                ? null
                : () {
                    if (LoginScreen.useRoleSelection) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoleSelectionPage(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(
                            selectedRole: LoginScreen.defaultRole,
                          ),
                        ),
                      );
                    }
                  },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.blue,
              side: const BorderSide(color: Colors.blue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Create New Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Alternative text link (backup option)
        /*
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account? ",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoleSelectionPage(),
                        ),
                      );
                    },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: const Text(
                'Sign up',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),*/
      ],
    );
  }
}
