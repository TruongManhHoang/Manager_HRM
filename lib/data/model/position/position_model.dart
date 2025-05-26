import 'package:hive/hive.dart';

part 'position_model.g.dart';

@HiveType(typeId: 3)
class PositionModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? code;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final String? positionType;

  @HiveField(5)
  final int? positionSalary;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  PositionModel({
    this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.positionType,
    required this.positionSalary,
    this.createdAt,
    this.updatedAt,
  });

  /// Clone with changes
  PositionModel copyWith({
    String? id,
    String? name,
    String? description,
    String? positionType,
    int? positionSalary,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? code,
  }) {
    return PositionModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      positionType: positionType ?? this.positionType,
      positionSalary: positionSalary ?? this.positionSalary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to Map (for Firebase or local)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'positionType': positionType,
      'positionSalary': positionSalary,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create from Map
  factory PositionModel.fromMap(Map<String, dynamic> map) {
    return PositionModel(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      description: map['description'],
      positionType: map['positionType'],
      positionSalary: map['positionSalary'],
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  /// Convert to JSON
  String toJson() => toMap().toString();

  /// Create from JSON
  factory PositionModel.fromJson(Map<String, dynamic> json) =>
      PositionModel.fromMap(json);

  @override
  String toString() {
    return 'PositionModel(id: $id, name: $name, description: $description, positionType: $positionType, positionSalary: $positionSalary, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PositionModel &&
        other.id == id &&
        other.code == code &&
        other.name == name &&
        other.description == description &&
        other.positionType == positionType &&
        other.positionSalary == positionSalary &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        name.hashCode ^
        description.hashCode ^
        positionType.hashCode ^
        positionSalary.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
