import 'package:flutter/material.dart';
import '../auth/domain/user_role.dart';
import 'admin_screen.dart';
import 'guest_screen.dart';
import 'lead_screen.dart';
import 'member_screen.dart';
import 'super_admin_screen.dart';

/// This project's role -> dashboard screen wiring, fed into DashboardRouter.
/// Swap this map's contents (not the auth module) when reusing the auth
/// flow in another project with different dashboards.
final Map<UserRole, WidgetBuilder> appDashboardRoutes = {
  UserRole.guest: (_) => const GuestScreen(),
  UserRole.member: (_) => const MemberScreen(),
  UserRole.lead: (_) => const LeadScreen(),
  UserRole.admin: (_) => const AdminScreen(),
  UserRole.superadmin: (_) => const SuperAdminScreen(),
};
