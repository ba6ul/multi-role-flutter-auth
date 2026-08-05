import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../cubit/app_user_cubit.dart';
import '../../domain/entities/user_profile.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/user_role.dart';
import '../../domain/usecase/current_user.dart';
import '../../domain/usecase/delete_account.dart';
import '../../domain/usecase/user_login.dart';
import '../../domain/usecase/user_sign_out.dart';
import '../../domain/usecase/user_signup.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final UserSignOut _userSignOut;
  final DeleteAccount _deleteAccount;
  final AppUserCubit _appUserCubit;
  // Optional host-app hooks, run on logout/account deletion. This module is
  // reused across projects with different local data to clean up (or none
  // at all), so it deliberately doesn't know what that data is — each host
  // app's own DI wiring supplies (or omits) them. Keeps this file identical
  // across those projects; only the host app's own setup code differs.
  final Future<void> Function()? _onLogout;
  final Future<void> Function()? _onAccountDeleted;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required UserSignOut userSignOut,
    required DeleteAccount deleteAccount,
    required AppUserCubit appUserCubit,
    Future<void> Function()? onLogout,
    Future<void> Function()? onAccountDeleted,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _currentUser = currentUser,
       _userSignOut = userSignOut,
       _deleteAccount = deleteAccount,
       _appUserCubit = appUserCubit,
       _onLogout = onLogout,
       _onAccountDeleted = onAccountDeleted,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignup>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLogout>(_onAuthLogout);
    on<AuthDeleteAccount>(_onAuthDeleteAccount);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) => emit(AuthFailure(l.message)),
      (r) => _emitAuthSuccess(r, emit),
    );
  }

  void _onAuthSignUp(AuthSignup event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        username: event.username,
        role: event.role,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(UserProfile user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }

  void _onAuthLogout(AuthLogout event, Emitter<AuthState> emit) {
    // Clear local state immediately rather than waiting on the network
    // sign-out call - if that request is slow or hangs (flaky connection,
    // wireless debugging, etc.), the UI would otherwise sit on AuthLoading
    // forever. The user's intent to be signed out on this device is
    // satisfied locally regardless of what the network call does.
    _appUserCubit.updateUser(null);
    emit(AuthInitial());
    // Best-effort remote sign-out — fire and forget, not on the critical path.
    _userSignOut(NoParams());
    // Host-app cleanup hook — same fire-and-forget treatment; a slow local
    // clear shouldn't block the UI any more than the network call should.
    _onLogout?.call();
  }

  void _onAuthDeleteAccount(
    AuthDeleteAccount event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _deleteAccount(NoParams());

    res.fold((failure) => emit(AuthFailure(failure.message)), (_) {
      _appUserCubit.updateUser(null);
      emit(AuthInitial());
      _onAccountDeleted?.call();
    });
  }
}
