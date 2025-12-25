
import 'package:multi_role_flutter_auth/core/common/entities/user_entity.dart';

class UserModel extends Userprofiles {
  UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.username,
    required super.role,
  });

  // Factory to create a UserModel from Supabase JSON response
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['user_id'] ?? '',
      email: map['email'] ?? '',
      name: map['username'] ?? '',
      username: map['username'] ?? '',
      // Convert String back to Enum
      role: map['role'] ?? '',
    );
  }
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      role: role ?? this.role,
    );
  }
}