// lib/core/config/api_keys.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  static late final String supabaseUrl;
  static late final String supabaseAnon;

  static void init() {
    supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    supabaseAnon = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    if (supabaseUrl.isEmpty) {
      throw Exception("SUPABASE_URL missing in .env");
    }
    if (supabaseAnon.isEmpty) {
      throw Exception("SUPABASE_ANON_KEY missing in .env");
    }
  }
}
