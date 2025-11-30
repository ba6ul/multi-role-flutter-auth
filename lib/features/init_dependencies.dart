import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_role_flutter_auth/core/config/api_keys.dart';
import 'package:multi_role_flutter_auth/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:multi_role_flutter_auth/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/repository/auth_repository.dart';
import 'package:multi_role_flutter_auth/features/auth/domain/usecase/user_signup.dart';
import 'package:multi_role_flutter_auth/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Load environment variables from the .env file
  await dotenv.load(fileName: ".env");
  ApiKeys.init();

  // Initialize Supabase
  final supabase = await Supabase.initialize(
    url: ApiKeys.supabaseUrl,
    anonKey: ApiKeys.supabaseAnon,
  );

  // Register Supabase client
  serviceLocator.registerLazySingleton(() => supabase.client);

  // Initialize Auth dependencies
  _initAuth();
}

/// Initialize Auth dependencies
void _initAuth() {
  // DataSource needs supabase client
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator()),
  );

  // Repository needs datasource
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator()),
  );

  // Usecase needs repo
  serviceLocator.registerFactory(() => UserSignUp(serviceLocator()));

  // Bloc needs usecase
  serviceLocator.registerLazySingleton(
    () => AuthBloc(userSignUp: serviceLocator()),
  );
}
