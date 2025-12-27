import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_role_flutter_auth/features/init_dependencies.dart';


// Pages
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/login_screen.dart';
import 'package:multi_role_flutter_auth/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize environment variables and dependencies
  await initDependencies();
 
  runApp(
    MultiBlocProvider(
      providers: [

        // Auth Bloc
        BlocProvider(
          create: (_) =>serviceLocator<AuthBloc>(),
        ),
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
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}