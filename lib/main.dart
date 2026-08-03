import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/cubit/app_user_cubit.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/init_dependencies.dart';

// Pages
import 'features/auth/presentation/pages/auth_gate.dart';
import 'utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize environment variables and dependencies
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: serviceLocator<AppUserCubit>()),

        // Auth Bloc
        BlocProvider(create: (_) => serviceLocator<AuthBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'multi_role_flutter_auth',
      themeMode: ThemeMode.system,
      theme: HAppTheme.lightTheme,
      darkTheme: HAppTheme.darkTheme,
      home: const AuthGate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
