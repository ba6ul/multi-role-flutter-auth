import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth_kit/flutter_auth_kit.dart';
import '../../../../common/widgets/loader.dart';
import 'login_screen.dart';
import '../router/dashboard_router.dart';
import '../../../dashboard/dashboard_routes.dart';

/// App entry point: checks for an existing session on launch and routes
/// straight to the user's dashboard if one is found, otherwise falls
/// through to [LoginScreen].
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    // A one-time decision made imperatively via Navigator, not a reactive
    // BlocBuilder that keeps swapping the whole screen on every subsequent
    // AuthBloc state change. LoginScreen has its own BlocConsumer and
    // manages its own login attempts - if AuthGate stayed mounted and kept
    // rebuilding around it (e.g. on the AuthLoading every login attempt
    // emits), it would tear LoginScreen down mid-attempt, and LoginScreen's
    // listener would never live long enough to see the eventual
    // AuthFailure/AuthSuccess. pushAndRemoveUntil below removes AuthGate
    // from the stack entirely once it's made this one decision, so only
    // LoginScreen's (or DashboardRouter's) own listener reacts after that.
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => DashboardRouter(
                role: state.user.role,
                routes: appDashboardRoutes,
              ),
            ),
            (route) => false,
          );
        } else if (state is AuthFailure) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: const Scaffold(body: Loader()),
    );
  }
}
