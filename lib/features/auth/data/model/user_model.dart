// lib/features/auth/data/models/user_model.dart
//import '../../domain/entities/user_entity.dart'; // import your entity
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/user_role.dart'; // import your enum
import 'package:multi_role_flutter_auth/core/common/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
  });

  // Factory to create a UserModel from Supabase JSON response
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['user_id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      // Convert String back to Enum
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'], 
        orElse: () => UserRole.guest,
      ),
    );
  }
  
  // Create UserModel from Supabase User Object and Metadata
  factory UserModel.fromSupabaseUser(User user, Map<String, dynamic>? profileData) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      name: profileData?['name'] ?? '',
      role: UserRole.values.firstWhere(
         (e) => e.name == profileData?['role'],
         orElse: () => UserRole.guest
      ),
    );
  }
}