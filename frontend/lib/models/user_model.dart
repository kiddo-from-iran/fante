class UserModel {
  const UserModel({
    required this.id,
    required this.fullName,
    this.email,
    this.phoneNumber,
    this.profilePicture,
    this.isActive = true,
    this.roleId,
    this.createdAt,
  });

  final int id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? profilePicture;
  final bool isActive;
  final int? roleId;
  final DateTime? createdAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      fullName: json['full_name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      profilePicture: json['profile_picture'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      roleId: json['role_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'profile_picture': profilePicture,
        'is_active': isActive,
        'role_id': roleId,
        'created_at': createdAt?.toIso8601String(),
      };

  UserModel copyWith({
    String? fullName,
    String? profilePicture,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      isActive: isActive,
      roleId: roleId,
      createdAt: createdAt,
    );
  }
}
