import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'auth/presentation/cubit/app_user_cubit.dart';
import '../core/config/api_keys.dart';
import 'auth/data/datasource/auth_remote_data_source.dart';
import 'auth/data/repositories/auth_repository_impl.dart';
import 'auth/domain/repository/auth_repository.dart';
import 'auth/domain/usecase/current_user.dart';
import 'auth/domain/usecase/delete_account.dart';
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
