class AccountModel {
  final String? id;
  final String code;
  final String name;
  final String employeeId;
  final String email;
  final String password;
  final String role;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AccountModel({
    this.id,
    required this.name,
    required this.code,
    required this.employeeId,
    required this.email,
    required this.password,
    required this.role,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code: json['code'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      role: json['role'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'employeeId': employeeId,
      'email': email,
      'password': password,
      'role': role,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  AccountModel copyWith({
    String? id,
    String? name,
    String? code,
    String? employeeId,
    String? email,
    String? password,
    String? role,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AccountModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
