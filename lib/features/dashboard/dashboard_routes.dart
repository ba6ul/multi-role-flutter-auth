import 'package:flutter/material.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/user_role.dart';
import 'package:multi_role_flutter_auth/features/dashboard/admin_screen.dart';
import 'package:multi_role_flutter_auth/features/dashboard/guest_screen.dart';
import 'package:multi_role_flutter_auth/features/dashboard/lead_screen.dart';
import 'package:multi_role_flutter_auth/features/dashboard/member_screen.dart';
import 'package:multi_role_flutter_auth/features/dashboard/super_admin_screen.dart';

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
