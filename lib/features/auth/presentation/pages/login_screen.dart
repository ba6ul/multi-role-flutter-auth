import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Your Clean Architecture / Core Imports
import 'package:multi_role_flutter_auth/core/common/widgets/loader.dart';
import 'package:multi_role_flutter_auth/core/config/auth_config.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/signup_screen.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/router/dashboard_router.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/widgets/auth_field.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/role_selection_page.dart';

// Your Utility / Theme Imports
import 'package:multi_role_flutter_auth/utils/constants/color.dart';
import 'package:multi_role_flutter_auth/utils/constants/sizes.dart';
import 'package:multi_role_flutter_auth/utils/constants/text_strings.dart';
import 'package:multi_role_flutter_auth/utils/show_snackbar.dart';
import 'package:multi_role_flutter_auth/utils/validators/validators.dart';

class LoginScreen extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const LoginScreen());
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Triggers the Bloc event for logging in
  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLogin(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HColors.lightBackground,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          } else if (state is AuthSuccess) {
            // After successful login, navigate to Dashboard with the user's role
            final userRole = UserRole.values.firstWhere(
              (role) => role.name == state.user.role,
              orElse: () => UserRole.admin,
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => DashboardRouter(role: userRole),
              ),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          // Show the loader
          if (state is AuthLoading) {
            return const Loader();
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeroSection(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: HSizes.spaceBtwSections,
                  ),
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
                            const Text(
                              HTexts.signIn,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: HColors.primary,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(height: HSizes.spaceBtwSections),

                            // Email Field
                            AuthField(
                              hintText: HTexts.email,
                              labelText: HTexts.email,
                              prefixIcon: Icons.alternate_email_rounded,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
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
                              validator: HValidator.validateLoginPassword,
                              onFieldSubmitted: (_) => _onLoginPressed(),
                            ),

                            const SizedBox(height: HSizes.defaultSpace / 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Remember Me Checkbox
                                Row(
                                  children: [
                                    Checkbox(
                                      value: false,
                                      onChanged: (value) {},
                                    ),
                                    const Text(HTexts.rememberMe),
                                  ],
                                ),

                                // Forgot Password
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    HTexts.forgetPasswordTitle,
                                    style: TextStyle(
                                      color: HColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: HSizes.defaultSpace),
                            Row(
                              
                              children: [
                                Expanded(child: _buildSignupSection(context)),
                                const SizedBox(
                                  width: HSizes.spaceBtwInputFields,
                                ), // Add some gap between them
                                
                                Expanded(child: _buildLoginButton()),
                              ],
                            ),
                            const SizedBox(height: HSizes.defaultSpace),
                            // Login Button
                            //_buildLoginButton(),

                            //const SizedBox(height: HSizes.defaultSpace),

                            //_buildSignupSection(context),
                          ],
                        ),
                      ),
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

  /// Visual section with Logo and Title
  // Needs to be its own widget to avoid rebuilds on Bloc changes
  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, bottom: 60),
      decoration: const BoxDecoration(
        color: HColors.secondary,
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
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: HColors.primary,
            ),
          ),
          Text(
            HTexts.loginSubTitle,
            style: TextStyle(
              color: HColors.primary.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the Primary Sign In Button
  // widgets of its own to avoid rebuilds on Bloc changes
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _onLoginPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: HColors.primary,
          foregroundColor: HColors.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: const Text(
          HTexts.signIn,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// Builds the Signup/Navigation section at the bottom
  Widget _buildSignupSection(BuildContext context) {
return
        SizedBox(
          height: 50,
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              if (AuthConfig.useRoleSelection) {
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
                      selectedRole: AuthConfig.defaultRole,
                    ),
                  ),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: HColors.primary,
              side: const BorderSide(color: HColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              HTexts.createAccount,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        );
  }
}
