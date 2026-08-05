/// Reusable multi-role auth logic (Supabase-backed): bloc/cubit, domain
/// entities/usecases, repository, and Supabase wiring. Deliberately has no
/// UI - screens stay app-owned so they can look completely different per
/// host app.
library;

export 'src/auth/config/supabase_schema.dart';
export 'src/auth/data/datasource/auth_remote_data_source.dart';
export 'src/auth/data/model/user_model.dart';
export 'src/auth/data/repositories/auth_repository_impl.dart';
export 'src/auth/domain/entities/user_profile.dart';
export 'src/auth/domain/repository/auth_repository.dart';
export 'src/auth/domain/usecase/current_user.dart';
export 'src/auth/domain/usecase/delete_account.dart';
export 'src/auth/domain/usecase/user_login.dart';
export 'src/auth/domain/usecase/user_sign_out.dart';
export 'src/auth/domain/usecase/user_signup.dart';
export 'src/auth/domain/user_role.dart';
export 'src/auth/presentation/bloc/auth_bloc.dart';
export 'src/auth/presentation/cubit/app_user_cubit.dart';
