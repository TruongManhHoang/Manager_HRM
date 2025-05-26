import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String id;
  final String userId;
  final String? userName;
  final String? date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final String? workLocation;
  final double? numberOfHours;
  final String? notes;
  final bool isLate;
  final bool isAbsent;
  final DateTime createdAt;
  final DateTime updatedAt;

  AttendanceModel({
    required this.id,
    required this.userId,
    this.userName,
    this.date,
    this.checkInTime,
    this.checkOutTime,
    this.workLocation,
    this.numberOfHours,
    this.notes,
    this.isLate = false,
    this.isAbsent = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return AttendanceModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      date: json['date'] ?? '',
      checkInTime: parseDate(json['checkInTime']) ?? DateTime.now(),
      checkOutTime: parseDate(json['checkOutTime']) ?? DateTime.now(),
      workLocation: json['workLocation'] ?? '',
      numberOfHours: json['numberOfHours']?.toDouble() ?? 0,
      notes: json['notes'] ?? '',
      isLate: json['isLate'] ?? false,
      isAbsent: json['isAbsent'] ?? false,
      createdAt: parseDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: parseDate(json['updatedAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'date': date,
      'checkInTime': checkInTime?.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'workLocation': workLocation,
      'numberOfHours': numberOfHours,
      'notes': notes,
      'isLate': isLate,
      'isAbsent': isAbsent,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AttendanceModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? workLocation,
    double? numberOfHours,
    String? notes,
    bool? isLate,
    bool? isAbsent,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      workLocation: workLocation ?? this.workLocation,
      numberOfHours: numberOfHours ?? this.numberOfHours,
      notes: notes ?? this.notes,
      isLate: isLate ?? this.isLate,
      isAbsent: isAbsent ?? this.isAbsent,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
