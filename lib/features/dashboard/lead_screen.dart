import 'package:flutter/material.dart';
import '../auth/presentation/widgets/sign_out_button.dart';

class LeadScreen extends StatelessWidget {
  final String title;
  const LeadScreen({super.key, this.title = ''});

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
