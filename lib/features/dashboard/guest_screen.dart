import 'package:flutter/material.dart';

class GuestScreen extends StatelessWidget {
  final String title;
  const GuestScreen({super.key, this.title = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title.isEmpty ? 'Dashboard' : title),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
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

class SimpleAdminScreen extends StatelessWidget {
  const SimpleAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GuestScreen(title: 'Fleet Manager Dashboard');
  }
}
