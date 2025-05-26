import 'package:hive/hive.dart';

part 'department_model.g.dart';

@HiveType(typeId: 2)
class DepartmentModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final String? managerName;
  @HiveField(4)
  final DateTime? createdAt;
  @HiveField(5)
  final DateTime? updatedAt;
  @HiveField(6)
  final String status;
  @HiveField(7)
  final int? employeeCount;
  @HiveField(8)
  final String? code;
  @HiveField(9)
  final String? email;
  @HiveField(10)
  final String? phoneNumber;

  DepartmentModel({
    this.id,
    required this.name,
    this.description,
    this.managerName,
    this.createdAt,
    this.updatedAt,
    required this.status,
    this.employeeCount,
    this.code,
    this.email,
    this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'managerName': managerName,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status,
      'employeeCount': employeeCount,
      'code': code,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      managerName: map['managerName'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      status: map['status'],
      employeeCount: map['employeeCount'] ?? 0,
      code: map['code'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
    );
  }

  DepartmentModel copyWith({
    String? id,
    String? name,
    String? description,
    String? managerName,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
    int? employeeCount,
    String? code,
    String? email,
    String? phoneNumber,
  }) {
    return DepartmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      managerName: managerName ?? this.managerName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
      employeeCount: employeeCount ?? this.employeeCount,
      code: code ?? this.code,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
