import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multi_role_flutter_auth/core/config/api_keys.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:multi_role_flutter_auth/features/init_dependencies.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Pages
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/login_screen.dart';

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
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}