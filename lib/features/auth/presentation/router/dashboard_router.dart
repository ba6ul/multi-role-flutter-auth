import 'package:flutter/material.dart';
import 'package:multi_role_flutter_auth/features/dashboard/admin_screen.dart';
import 'package:multi_role_flutter_auth/features/dashboard/guest_screen.dart';
import 'package:multi_role_flutter_auth/features/dashboard/lead_screen.dart';
import 'package:multi_role_flutter_auth/features/dashboard/member_screen.dart';
import 'package:multi_role_flutter_auth/features/dashboard/super_admin_screen.dart';
import '../../domain/user_role.dart';

//Page router
class DashboardRouter extends StatelessWidget {
  final UserRole role;

  const DashboardRouter({super.key, required this.role});

  static final Map<UserRole, Widget Function()> _routes = {
    UserRole.guest: () => const GuestScreen(),
    UserRole.member: () => const MemberScreen(),
    UserRole.lead: () => const LeadScreen(),
    UserRole.admin: () => const AdminScreen(),
    UserRole.superadmin: () => const SuperAdminScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return _routes[role]?.call() ?? const GuestScreen();
  }
}




