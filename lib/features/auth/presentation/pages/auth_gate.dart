import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_role_flutter_auth/core/common/widgets/loader.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/login_screen.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/router/dashboard_router.dart';
import 'package:multi_role_flutter_auth/features/dashboard/dashboard_routes.dart';

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
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          return DashboardRouter(role: state.user.role, routes: appDashboardRoutes);
        }
        if (state is AuthFailure) {
          return const LoginScreen();
        }
        // AuthInitial or AuthLoading: the session check hasn't resolved yet.
        return const Scaffold(body: Loader());
      },
    );
  }
}
