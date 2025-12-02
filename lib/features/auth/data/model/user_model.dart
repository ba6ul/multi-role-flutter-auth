
import 'package:multi_role_flutter_auth/core/common/entities/user_entity.dart';

class UserModel extends Userprofiles {
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
      role: map['role'] ?? '',
    );
  }
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }
}