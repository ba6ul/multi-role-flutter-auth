import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Your Architecture / Core Imports
import 'package:multi_role_flutter_auth/core/common/widgets/loader.dart';
import 'package:multi_role_flutter_auth/core/config/auth_config.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/profile_setup_page.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/router/dashboard_router.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/widgets/auth_field.dart';

// Utility / Theme Imports
import 'package:multi_role_flutter_auth/utils/constants/color.dart';
import 'package:multi_role_flutter_auth/utils/constants/sizes.dart';
import 'package:multi_role_flutter_auth/utils/show_snackbar.dart';
import 'package:multi_role_flutter_auth/utils/validators/validators.dart';

class SignupScreen extends StatefulWidget {
  final UserRole selectedRole;
  const SignupScreen({super.key, required this.selectedRole});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _agreeToLegal = false;
  bool _subscribeNewsletter = false;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HColors.primaryBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Using a standard size for the back button to maintain alignment with the text below
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: HColors.primary,
            size: 22,
          ),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          } else if (state is AuthSuccess) {
            // NAVIGATION LOGIC BASED ON CONFIG
            if (AuthConfig.useProfileCompletion) {
              // Redirect directly to Profile Completion
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProfileSetupPage(selectedRole: widget.selectedRole),
                ),
              );
            } else {
              // Redirect to Dashboard
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
            builder: (context) => DashboardRouter(role: widget.selectedRole),
          ), // Replace with your DashboardPage()
                (route) => false, // Clears the navigation stack
              );
            }
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) return const Loader();

          return SingleChildScrollView(
            // physics: const BouncingScrollPhysics() ensures a smooth feel on both OS
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: HSizes.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Form(
                  key: _formKey,
                  child: Column(
                    // Strict alignment ensures responsiveness
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. FIXED TOP BUFFER
                      // This ensures that even if the badge is hidden,
                      // the text doesn't jump too close to the AppBar.
                      const SizedBox(height: HSizes.sm),

                      // 2. RESPONSIVE ROLE BADGE
                      if (AuthConfig.showRoleBadgeOnSignup) ...[
                        _buildRoleBadge(),
                        const SizedBox(height: HSizes.md),
                      ],

                      // 3. HEADER SECTION
                      const Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: HColors.primary,
                          letterSpacing: -1.2,
                        ),
                      ),
                      const SizedBox(height: HSizes.xs),
                      Text(
                        "Fill in the details below to set up your account.",
                        style: TextStyle(color: Colors.grey[600], fontSize: 15),
                      ),

                      const SizedBox(height: HSizes.spaceBtwSections),

                      // INPUT FIELDS
                      AuthField(
                        hintText: "Username",
                        labelText: "Username",
                        prefixIcon: Icons.person_outline_rounded,
                        controller: _usernameController,
                        validator: (val) =>
                            val!.isEmpty ? "Username is required" : null,
                      ),
                      const SizedBox(height: HSizes.spaceBtwInputFields),

                      AuthField(
                        hintText: "Email",
                        labelText: "Email",
                        prefixIcon: Icons.alternate_email_rounded,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: HValidator.validateEmail,
                      ),
                      const SizedBox(height: HSizes.spaceBtwInputFields),

                      AuthField(
                        hintText: "Password",
                        labelText: "Password",
                        prefixIcon: Icons.lock_outline_rounded,
                        controller: _passwordController,
                        obscureText: true,
                        validator: HValidator.validatePassword,
                      ),
                      const SizedBox(height: HSizes.spaceBtwInputFields),

                      AuthField(
                        hintText: "Confirm Password",
                        labelText: "Confirm Password",
                        prefixIcon: Icons.lock_reset_rounded,
                        controller: _confirmPasswordController,
                        obscureText: true,
                        validator: (val) => val != _passwordController.text
                            ? "Passwords do not match"
                            : null,
                      ),

                      const SizedBox(height: HSizes.spaceBtwSections),

                      // LEGAL & NEWSLETTER
                      _buildLegalCheckbox(),
                      const SizedBox(height: HSizes.spaceBtwItems),
                      _buildNewsletterCheckbox(),

                      const SizedBox(height: HSizes.spaceBtwSections),

                      // PRIMARY BUTTON
                      _buildSignupButton(),

                      // SOCIAL AUTH
                      const SizedBox(height: HSizes.spaceBtwSections),
                      _buildSocialDivider(),
                      const SizedBox(height: HSizes.spaceBtwItems),
                      _buildSocialButtons(),

                      // Extra bottom padding for scrollability
                      const SizedBox(height: HSizes.spaceBtwSections),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildRoleBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: HColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: HColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.selectedRole.icon, size: 14, color: HColors.primary),
          const SizedBox(width: 8),
          Text(
            widget.selectedRole.displayName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: HColors.primary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalCheckbox() {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _agreeToLegal,
            activeColor: HColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (val) => setState(() => _agreeToLegal = val!),
          ),
        ),
        const SizedBox(width: HSizes.sm),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black87, fontSize: 13),
              children: [
                const TextSpan(text: "I agree to the "),
                TextSpan(
                  text: "Terms of Service",
                  style: const TextStyle(
                    color: HColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: const TextStyle(
                    color: HColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsletterCheckbox() {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _subscribeNewsletter,
            activeColor: HColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (val) => setState(() => _subscribeNewsletter = val!),
          ),
        ),
        const SizedBox(width: HSizes.sm),
        const Text(
          "I want to receive updates via newsletter",
          style: TextStyle(fontSize: 13, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return ElevatedButton(
            onPressed: state is AuthLoading ? null : _handleSignup,
            style: ElevatedButton.styleFrom(
              backgroundColor: HColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "Create Account",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate() && _agreeToLegal) {
      context.read<AuthBloc>().add(
        AuthSignup(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          username: _usernameController.text.trim(),
          role: widget.selectedRole.dbValue,
        ),
      );
    } else if (!_agreeToLegal) {
      showSnackBar(
        context,
        "Please agree to the Terms of Service and Privacy Policy",
      );
    }
  }

  Widget _buildSocialDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 0.8)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "Or join with",
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
          ),
        ),
        const Expanded(child: Divider(thickness: 0.8)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialIconButton(FontAwesomeIcons.google, Colors.red, () {}),
        const SizedBox(width: 25),
        _socialIconButton(
          FontAwesomeIcons.facebook,
          const Color(0xFF1877F2),
          () {},
        ),
        const SizedBox(width: 25),
        _socialIconButton(FontAwesomeIcons.github, Colors.black, () {}),
      ],
    );
  }

  Widget _socialIconButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.withOpacity(0.25)),
        ),
        child: FaIcon(icon, color: color, size: 24),
      ),
    );
  }
}
