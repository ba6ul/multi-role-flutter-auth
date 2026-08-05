import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../pages/auth_gate.dart';
import '../../../../utils/constants/colors.dart';

/// Drop into a Settings screen's Account section. Bundles sign-out and
/// account deletion together so both projects that share this auth module
/// get the same rows and the same confirmation dialog, in one place.
class AuthAccountSection extends StatelessWidget {
  const AuthAccountSection({super.key});

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () => context.read<AuthBloc>().add(AuthLogout()),
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: HColors.error),
            title: const Text(
              'Delete Account',
              style: TextStyle(color: HColors.error),
            ),
            onTap: () => _confirmDelete(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final authBloc = context.read<AuthBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'This permanently deletes your account and profile data. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(color: HColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      authBloc.add(AuthDeleteAccount());
    }
  }
}
