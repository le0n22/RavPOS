import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ravpos/shared/models/models.dart'; // UserRole

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String name,
    required String username,
    String? passwordHash, // Şimdilik basit String, gerçekte hash'lenecek
    required UserRole role,
    @Default(true) bool isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson({...json, 'id': json['id'].toString()});
} 