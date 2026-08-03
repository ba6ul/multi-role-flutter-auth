/// Table/column names for the Supabase `user_profiles` table used by the
/// auth flow. Change these in one place when reusing the auth module in a
/// project with a differently-named schema — no need to hunt through
/// individual data/service files for hardcoded strings.
class SupabaseSchema {
  static const String userProfilesTable = 'user_profiles';

  static const String userIdColumn = 'user_id';
  static const String customUserIdColumn = 'custom_user_id';
  static const String roleColumn = 'role';
  static const String profileCompletedColumn = 'profile_completed';
}
