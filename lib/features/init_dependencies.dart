import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'auth/presentation/cubit/app_user_cubit.dart';
import '../core/config/api_keys.dart';
import '../core/network/connection_checker.dart';
import 'auth/data/datasource/auth_remote_data_source.dart';
import 'auth/data/repositories/auth_repository_impl.dart';
import 'auth/domain/repository/auth_repository.dart';
import 'auth/domain/usecase/current_user.dart';
import 'auth/domain/usecase/user_login.dart';
import 'auth/domain/usecase/user_sign_out.dart';
import 'auth/domain/usecase/user_signup.dart';
import 'auth/presentation/bloc/auth_bloc.dart';
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
  serviceLocator.registerFactory(() => InternetConnection());

  // Initialize Auth dependencies
  _initAuth();
}

/// Initialize Auth dependencies
void _initAuth() {
  // 1. Register Core/Common dependencies (The missing links!)
  // Register ConnectionChecker (Assuming you have an implementation class)
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );

  // Register AppUserCubit (This is needed by AuthBloc)
  // Ensure you have imported this at the top!
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  // 2. Datasource
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(), // SupabaseClient
    ),
  );

  // 3. Repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(), // AuthRemoteDataSource
      serviceLocator(), // ConnectionChecker (This will work now)
    ),
  );

  // 4. Use cases
  serviceLocator
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => UserSignOut(serviceLocator()));

  // 5. Bloc
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      userSignOut: serviceLocator(),
      appUserCubit: serviceLocator(), // This will work now
    ),
  );
}
