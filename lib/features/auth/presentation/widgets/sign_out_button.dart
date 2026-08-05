import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_auth_kit/flutter_auth_kit.dart';
import '../pages/auth_gate.dart';

/// Drop into a dashboard's AppBar actions. Dispatches AuthLogout and
/// navigates back to AuthGate once the bloc confirms the sign-out.
class SignOutButton extends StatelessWidget {
  const SignOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AuthGate()),
            (route) => false,
          );
        }
      },
      child: IconButton(
        tooltip: 'Sign out',
        icon: const Icon(Icons.logout),
        onPressed: () => context.read<AuthBloc>().add(AuthLogout()),
      ),
    );
  }
}
