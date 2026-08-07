import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_auth_kit/flutter_auth_kit.dart';
import '../core/config/api_keys.dart';
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
  // Register AppUserCubit (This is needed by AuthBloc)
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  // 1. Datasource
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator(), // SupabaseClient
    ),
  );

  // 2. Repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(), // AuthRemoteDataSource
    ),
  );

  // 3. Use cases
  serviceLocator
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    ..registerFactory(() => UserSignOut(serviceLocator()))
    ..registerFactory(() => DeleteAccount(serviceLocator()));

  // 4. Bloc
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      userSignOut: serviceLocator(),
      deleteAccount: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}
