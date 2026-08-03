import 'package:flutter/material.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/widgets/sign_out_button.dart';

class MemberScreen extends StatelessWidget {
  final String title;
  const MemberScreen({super.key, this.title = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title.isEmpty ? 'Dashboard' : title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: const [SignOutButton()],
      ),
      body: const Center(
        child: Text(
          'Welcome to your dashboard!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
