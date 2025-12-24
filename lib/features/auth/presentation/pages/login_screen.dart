import 'package:flutter/material.dart';
import 'package:multi_role_flutter_auth/features/auth/data/UserProfileService.dart'
    as user_profile_service;
import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/signup_screen.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/widgets/auth_field.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/role_selection_page.dart';
import 'package:multi_role_flutter_auth/utils/constants/color.dart';
import 'package:multi_role_flutter_auth/utils/constants/sizes.dart';
import 'package:multi_role_flutter_auth/utils/constants/text_strings.dart';
import 'package:multi_role_flutter_auth/utils/validators/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../router/dashboard_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  // The user role selection page will be hidden
  static const bool useRoleSelection = false;

  // This gives a default role if the role section is dsabled
  static const UserRole defaultRole = UserRole.admin;


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
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: HSizes.spaceBtwSections),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                horizontal: HSizes.lg,
                vertical: HSizes.spaceBtwSections,
              ),
                  child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(HTexts.signIn,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: HColors.primary,
                              letterSpacing: -1,
                            )),

                        const SizedBox(height: HSizes.spaceBtwSections),

                        // Email Field
                        AuthField(
                          hintText: HTexts.email,
                          labelText: HTexts.email,
                          prefixIcon: Icons.alternate_email_rounded,
                          controller: _emailController,
                          keyboardType:
                              TextInputType.emailAddress, // Added for better UX
                          validator: HValidator.validateEmail,
                        ),
                        const SizedBox(height: HSizes.spaceBtwInputFields),

                        // Password Field
                        AuthField(
                          hintText: HTexts.password,
                          labelText: HTexts.password,
                          prefixIcon: Icons.lock,
                          controller: _passwordController,
                          obscureText: true,
                          validator: HValidator
                              .validateLoginPassword,
                          onFieldSubmitted: (_) => _login(),
                        ),

                        const SizedBox(height: HSizes.defaultSpace),

                        // Error Message
                        if (_errorMessage != null) ...[
                          _buildErrorMessage(),
                         const SizedBox(height: HSizes.spaceBtwItems),
                        ],

                        // Login Button
                        _buildLoginButton(context),

                        const SizedBox(height: HSizes.defaultSpace),

                        _buildSignupSection(context),
                        // _buildDivider(),
                        // const SizedBox(height: HSizes.defaultSpace),
                         //Google and Facebook Login Buttons goes here
                      ],
                    ),
                  ),
                ),
              ),
      )] ),
          ));
        
  }
Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, bottom: 60),
      decoration: const BoxDecoration(
        color: HColors.secondary, // Vanilla Cream color
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(80)),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [HColors.primary, HColors.primary],
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: const FlutterLogo(size: 70),
          ),
          const SizedBox(height: HSizes.md),
          const Text(
            HTexts.appName,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: HColors.primary),
          ),
          Text(
            HTexts.loginSubTitle,
            style: TextStyle(color: HColors.primary.withOpacity(0.5), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
 

  // Reusable error message widget
  Widget _buildErrorMessage() {
    return Container(
      margin: const EdgeInsets.only(bottom: HSizes.md),
      padding: const EdgeInsets.all(HSizes.md),
      decoration: BoxDecoration(
        color: HColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(HSizes.borderRadiusMd),
        border: Border.all(color: HColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: HColors.error, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _errorMessage!, 
              style: const TextStyle(color: HColors.error, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  // Customizable login button
  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: HColors.primary,
          foregroundColor: HColors.secondary,
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
                HTexts.signIn,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
/*
  // Reusable divider
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            HTexts.orSignInWith,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }
*/
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
              foregroundColor: HColors.primary,
              side: BorderSide(color: HColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              HTexts.createAccount,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 16),

      ],
    );
  }
}
