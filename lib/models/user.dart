class UserModel {
  final int userId;
  final String fullName;
  final String email;
  final String password;
  final String role;
  final String? phone;
  final String? address;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    this.phone,
    this.address,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['UserID'],
      fullName: json['FullName'],
      email: json['Email'],
      password: json['Password'],
      role: json['Role'],
      phone: json['Phone'],
      address: json['Address'],
      createdAt: DateTime.parse(json['CreatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userId,
      'FullName': fullName,
      'Email': email,
      'Password': password,
      'Role': role,
      'Phone': phone,
      'Address': address,
      'CreatedAt': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toJsonForCreate() {
    return {
      'FullName': fullName,
      'Email': email,
      'Password': password,
      'Role': role,
      'Phone': phone,
      'Address': address,
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    final Map<String, dynamic> data = {
      'FullName': fullName,
      'Email': email,
      'Role': role,
      'Phone': phone,
      'Address': address,
    };

    // Only include password if it's not empty (for updates)
    if (password.isNotEmpty) {
      data['Password'] = password;
    }

    return data;
  }

  UserModel copyWith({
    int? userId,
    String? fullName,
    String? email,
    String? password,
    String? role,
    String? phone,
    String? address,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
