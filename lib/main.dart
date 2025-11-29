import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multi_role_flutter_auth/core/config/api_keys.dart';
import 'package:multi_role_flutter_auth/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:multi_role_flutter_auth/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/repository/signup.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Pages
import 'package:multi_role_flutter_auth/features/auth/presentation/pages/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the .env file
  await dotenv.load(fileName: ".env");
  ApiKeys.init();

  // Initialize Supabase
  await Supabase.initialize(
    url: ApiKeys.supabaseUrl,
    anonKey: ApiKeys.supabaseAnon,
  );

  runApp(
    MultiBlocProvider(
      providers: [
        // Add your BlocProviders here
        BlocProvider(
          create: (_) => AuthBloc(
            userSignUp: UserSignUp(
              AuthRepositoryImpl(AuthRemoteDataSourceImpl(Supabase.instance.client)),
            ),
          ),
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
