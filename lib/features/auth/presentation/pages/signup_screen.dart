import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Your Architecture / Core Imports
import 'package:multi_role_flutter_auth/core/common/widgets/loader.dart';
import 'package:multi_role_flutter_auth/core/config/auth_config.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/profile_setup_page.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/router/dashboard_router.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/widgets/auth_field.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/widgets/social_buttons.dart';
import 'package:multi_role_flutter_auth/features/dashboard/dashboard_routes.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? HColors.accent : HColors.primary;

    return Scaffold(
      // No explicit backgroundColor - inherit Theme.scaffoldBackgroundColor,
      // which is already correctly set per light/dark theme. Hardcoding it
      // here was the bug: it always stayed light even in dark mode, while
      // AuthField (which does check brightness) switched to dark styling -
      // dark-styled fields on a light page.
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Using a standard size for the back button to maintain alignment with the text below
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: accentColor, size: 22),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          } else if (state is AuthSuccess) {
            // Lets the platform's password manager offer to save what was
            // just entered - without this it never prompts, regardless of
            // autofillHints being set on the fields.
            TextInput.finishAutofillContext();
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
                  builder: (context) => DashboardRouter(
                    role: widget.selectedRole,
                    routes: appDashboardRoutes,
                  ),
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
                  child: AutofillGroup(
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
                        Text(
                          "Create Account",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: isDark ? HColors.light : HColors.primary,
                            letterSpacing: -1.2,
                          ),
                        ),
                        const SizedBox(height: HSizes.xs),
                        Text(
                          "Fill in the details below to set up your account.",
                          style: TextStyle(
                            color: isDark
                                ? HColors.light.withValues(alpha: 0.6)
                                : Colors.grey[600],
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: HSizes.spaceBtwSections),

                        // INPUT FIELDS
                        AuthField(
                          hintText: "Username",
                          labelText: "Username",
                          prefixIcon: Icons.person_outline_rounded,
                          controller: _usernameController,
                          autofillHints: const [AutofillHints.newUsername],
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
                          autofillHints: const [AutofillHints.email],
                          validator: HValidator.validateEmail,
                        ),
                        const SizedBox(height: HSizes.spaceBtwInputFields),

                        AuthField(
                          hintText: "Password",
                          labelText: "Password",
                          prefixIcon: Icons.lock_outline_rounded,
                          controller: _passwordController,
                          obscureText: true,
                          autofillHints: const [AutofillHints.newPassword],
                          validator: HValidator.validatePassword,
                        ),
                        const SizedBox(height: HSizes.spaceBtwInputFields),

                        AuthField(
                          hintText: "Confirm Password",
                          labelText: "Confirm Password",
                          prefixIcon: Icons.lock_reset_rounded,
                          controller: _confirmPasswordController,
                          obscureText: true,
                          autofillHints: const [AutofillHints.newPassword],
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
                        if (AuthConfig.showSocialLogin) ...[
                          const SizedBox(height: HSizes.spaceBtwSections),
                          SocialLoginSection(
                            onGoogleTap: () {},
                            onFacebookTap: () {},
                            onGithubTap: () {},
                            onGuestTap: () {},
                          ),
                        ],

                        // Extra bottom padding for scrollability
                        const SizedBox(height: HSizes.spaceBtwSections),
                      ],
                    ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? HColors.accent : HColors.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: accentColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.selectedRole.icon, size: 14, color: accentColor),
          const SizedBox(width: 8),
          Text(
            widget.selectedRole.displayName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: accentColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalCheckbox() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? HColors.accent : HColors.primary;
    final bodyColor = isDark ? HColors.light : Colors.black87;

    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _agreeToLegal,
            activeColor: accentColor,
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
              style: TextStyle(color: bodyColor, fontSize: 13),
              children: [
                const TextSpan(text: "I agree to the "),
                TextSpan(
                  text: "Terms of Service",
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(
                    color: accentColor,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = isDark ? HColors.accent : HColors.primary;

    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _subscribeNewsletter,
            activeColor: accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (val) => setState(() => _subscribeNewsletter = val!),
          ),
        ),
        const SizedBox(width: HSizes.sm),
        Text(
          "I want to receive updates via newsletter",
          style: TextStyle(
            fontSize: 13,
            color: isDark ? HColors.light : Colors.black87,
          ),
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
          role: widget.selectedRole,
        ),
      );
    } else if (!_agreeToLegal) {
      showSnackBar(
        context,
        "Please agree to the Terms of Service and Privacy Policy",
      );
    }
  }
}
