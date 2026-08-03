import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

// Your Clean Architecture / Core Imports
import '../../../../core/common/widgets/loader.dart';
import '../../config/auth_config.dart';
import '../bloc/auth_bloc.dart';
import 'signup_screen.dart';
import '../router/dashboard_router.dart';
import '../widgets/auth_field.dart';
import 'role_selection_page.dart';
import '../widgets/hero_widget.dart';
import '../widgets/social_buttons.dart';
import '../../../dashboard/dashboard_routes.dart';

// Utility / Theme Imports
import '../../../../utils/constants/color.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/show_snackbar.dart';
import '../../../../utils/validators/validators.dart';

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
  bool _rememberMe = true;

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

  Future<void> _onForgotPasswordPressed() async {
    final emailController = TextEditingController(
      text: _emailController.text.trim(),
    );
    var isSending = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: const Text('Reset password'),
              content: TextField(
                controller: emailController,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'you@example.com',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSending
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isSending
                      ? null
                      : () async {
                          final email = emailController.text.trim();
                          if (HValidator.validateEmail(email) != null) {
                            showSnackBar(context, 'Enter a valid email first');
                            return;
                          }

                          setDialogState(() => isSending = true);
                          try {
                            await Supabase.instance.client.auth
                                .resetPasswordForEmail(email);
                            if (dialogContext.mounted)
                              Navigator.pop(dialogContext);
                            if (mounted) {
                              showSnackBar(
                                context,
                                'Password reset email sent to $email',
                              );
                            }
                          } catch (e) {
                            setDialogState(() => isSending = false);
                            if (mounted) {
                              showSnackBar(
                                context,
                                'Could not send reset email: $e',
                              );
                            }
                          }
                        },
                  child: isSending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send reset link'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            showSnackBar(context, state.message);
          } else if (state is AuthSuccess) {
            // Lets the platform's password manager offer to save what was
            // just entered - without this it never prompts, regardless of
            // autofillHints being set on the fields.
            TextInput.finishAutofillContext();
            // After successful login, navigate to Dashboard with the user's role
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => DashboardRouter(
                  role: state.user.role,
                  routes: appDashboardRoutes,
                ),
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
                // Hero Section
                const HeroWidget(),

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
                        child: AutofillGroup(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Sign In Text
                              Text(
                                HTexts.signIn,
                                style: Theme.of(context).textTheme.displayLarge,
                              ),

                              const SizedBox(height: HSizes.spaceBtwSections),

                              // Email Field
                              AuthField(
                                hintText: HTexts.email,
                                labelText: HTexts.email,
                                prefixIcon: Icons.alternate_email_rounded,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                validator: HValidator.validateEmail,
                              ),

                              const SizedBox(
                                height: HSizes.spaceBtwInputFields,
                              ),

                              // Password Field
                              AuthField(
                                hintText: HTexts.password,
                                labelText: HTexts.password,
                                prefixIcon: Icons.lock,
                                controller: _passwordController,
                                obscureText: true,
                                autofillHints: const [AutofillHints.password],
                                validator: HValidator.validateLoginPassword,
                                onFieldSubmitted: (_) => _onLoginPressed(),
                              ),

                              const SizedBox(height: HSizes.defaultSpace / 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Remember Me Checkbox
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) => setState(
                                          () => _rememberMe = value ?? true,
                                        ),
                                      ),
                                      const Text(HTexts.rememberMe),
                                    ],
                                  ),

                                  // Forgot Password
                                  TextButton(
                                    onPressed: _onForgotPasswordPressed,
                                    child: Text(
                                      HTexts.forgetPasswordTitle,
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? HColors.accent
                                            : HColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: HSizes.defaultSpace),

                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        if (AuthConfig.useRoleSelection) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RoleSelectionPage(),
                                            ),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignupScreen(
                                                    selectedRole:
                                                        AuthConfig.defaultRole,
                                                  ),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text(HTexts.createAccount),
                                    ),
                                  ),

                                  const SizedBox(
                                    width: HSizes.spaceBtwInputFields,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _onLoginPressed,
                                      child: const Text(HTexts.signIn),
                                    ),
                                  ),
                                ],
                              ),
                              if (AuthConfig.showSocialLogin) ...[
                                const SizedBox(height: HSizes.defaultSpace),
                                SocialLoginSection(
                                  onGoogleTap: () {},
                                  onFacebookTap: () {},
                                  onGithubTap: () {},
                                  onGuestTap: () {},
                                ),
                              ],
                            ],
                          ),
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
}
