import 'package:flutter/material.dart';
import 'package:multi_role_flutter_auth/screens/admin_screen.dart';
import 'package:multi_role_flutter_auth/screens/guest_screen.dart';
import 'package:multi_role_flutter_auth/screens/lead_screen.dart';
import 'package:multi_role_flutter_auth/screens/member_screen.dart';
import 'package:multi_role_flutter_auth/screens/super_admin_screen.dart';
import '../models/user_role.dart';

//Dashboard imports


class DashboardRouter extends StatelessWidget {
  final UserRole role;

  const DashboardRouter({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case UserRole.guest:
        return const GuestScreen();
      case UserRole.member:
        return const MemberScreen();
      case UserRole.lead:
        return const LeadScreen();
      case UserRole.admin:
        return const AdminScreen();
      case UserRole.superadmin:
        return const SuperAdminScreen();
    }
  }
}



