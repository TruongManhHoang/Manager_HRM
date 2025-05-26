import 'package:admin_hrm/data/model/kpi/kpi_metric/kpi_metric.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KPIModel {
  final String id;
  final String userId;
  final String departmentId;
  final String period;
  final List<KPIMetric> metrics;
  final double totalScore;
  final String? evaluatorId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  KPIModel({
    required this.id,
    required this.userId,
    required this.departmentId,
    required this.period,
    required this.metrics,
    required this.totalScore,
    this.evaluatorId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KPIModel.fromJson(Map<String, dynamic> json) {
    return KPIModel(
      id: json['id'],
      userId: json['userId'],
      departmentId: json['departmentId'],
      period: json['period'],
      metrics: (json['metrics'] as List<dynamic>)
          .map((item) => KPIMetric.fromJson(item))
          .toList(),
      totalScore: (json['totalScore'] as num).toDouble(),
      evaluatorId: json['evaluatorId'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'departmentId': departmentId,
      'period': period,
      'metrics': metrics.map((e) => e.toJson()).toList(),
      'totalScore': totalScore,
      'evaluatorId': evaluatorId,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'departmentId': departmentId,
      'period': period,
      'metrics': metrics.map((e) => e.toMap()).toList(),
      'totalScore': totalScore,
      'evaluatorId': evaluatorId,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  KPIModel copyWith({
    String? id,
    String? userId,
    String? departmentId,
    String? period,
    List<KPIMetric>? metrics,
    double? totalScore,
    String? evaluatorId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return KPIModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      departmentId: departmentId ?? this.departmentId,
      period: period ?? this.period,
      metrics: metrics ?? this.metrics,
      totalScore: totalScore ?? this.totalScore,
      evaluatorId: evaluatorId ?? this.evaluatorId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
