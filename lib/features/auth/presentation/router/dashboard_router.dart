import 'package:flutter/material.dart';
import 'package:flutter_auth_kit/flutter_auth_kit.dart';

/// Routes to a role's dashboard screen.
///
/// This widget has no knowledge of any concrete dashboard screens — the
/// consuming app supplies [routes], a `UserRole -> WidgetBuilder` map (see
/// `lib/features/dashboard/dashboard_routes.dart` for this project's map).
/// This keeps the auth module portable: dropping it into another project
/// only requires supplying a different map, not editing this file.
class DashboardRouter extends StatelessWidget {
  final UserRole role;
  final Map<UserRole, WidgetBuilder> routes;

  const DashboardRouter({super.key, required this.role, required this.routes});

  @override
  Widget build(BuildContext context) {
    final builder = routes[role];
    if (builder == null) {
      return Scaffold(
        body: Center(
          child: Text('No dashboard registered for role: ${role.displayName}'),
        ),
      );
    }
    return builder(context);
  }
}
