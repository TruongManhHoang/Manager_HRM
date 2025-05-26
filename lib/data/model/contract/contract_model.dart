import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'contract_model.g.dart';

@HiveType(typeId: 4)
class ContractModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? contractCode;
  @HiveField(2)
  final String? employeeId;
  @HiveField(3)
  final String contractType;
  @HiveField(4)
  final int salary;
  @HiveField(5)
  final String description;
  @HiveField(6)
  final DateTime? startDate;
  @HiveField(7)
  final DateTime? endDate;
  @HiveField(8)
  final DateTime? createdAt;
  @HiveField(9)
  final DateTime? updatedAt;
  @HiveField(10)
  final String? status;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contractCode': contractCode,
      'employeeId': employeeId,
      'contractType': contractType,
      'salary': salary,
      'description': description,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'status': status,
    };
  }

  ContractModel({
    this.id,
    this.contractCode,
    this.employeeId,
    required this.contractType,
    required this.salary,
    required this.description,
    this.startDate,
    this.endDate,
    this.createdAt,
    this.updatedAt,
    this.status,
  });

  factory ContractModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ContractModel(
      id: json['id'],
      contractCode: json['contractCode'] ?? '',
      employeeId: json['employeeId'] ?? '',
      contractType: json['contractType'] ?? '',
      salary: (json['salary'] ?? 0).toInt(),
      description: json['description'] ?? '',
      startDate: (json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : null),
      endDate:
          (json['endDate'] != null ? DateTime.parse(json['endDate']) : null),
      createdAt: (json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null),
      updatedAt: (json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null),
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contractCode': contractCode,
      'employeeId': employeeId,
      'contractType': contractType,
      'salary': salary,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'status': status,
    };
  }

  ContractModel copyWith({
    String? id,
    String? contractCode,
    String? employeeId,
    String? contractType,
    int? salary,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? status,
  }) {
    return ContractModel(
      id: id ?? this.id,
      contractCode: contractCode ?? this.contractCode,
      employeeId: employeeId ?? this.employeeId,
      contractType: contractType ?? this.contractType,
      salary: salary ?? this.salary,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      status: status ?? this.status,
    );
  }

  /// ✅ Debug log
  @override
  String toString() {
    return 'ContractModel(id: $id, contractCode: $contractCode, employeeId: $employeeId, '
        'contractType: $contractType, '
        'salary: $salary, description: $description, startDate: $startDate, endDate: $endDate, '
        ' createdAt: $createdAt, updatedAt: $updatedAt, status: $status)';
  }
}
