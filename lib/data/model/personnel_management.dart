class PersionalManagement {
  String? id;
  String? code;
  String name;
  String dateOfBirth;
  String gender;
  String? positionId;
  String departmentId;
  String address;
  String phone;
  String email;
  String date;
  String? status;
  String? avatar;
  DateTime? createdAt;
  DateTime? updatedAt;
  PersionalManagement({
    this.id,
    required this.code,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    this.positionId,
    required this.departmentId,
    required this.address,
    required this.phone,
    required this.email,
    required this.date,
    this.status,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });
  PersionalManagement copyWith({
    String? id,
    String? code,
    String? name,
    String? dateOfBirth,
    String? gender,
    String? positionId,
    String? departmentId,
    String? address,
    String? phone,
    String? email,
    String? date,
    String? status,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PersionalManagement(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      positionId: positionId ?? this.positionId,
      departmentId: departmentId ?? this.departmentId,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      date: date ?? this.date,
      status: status ?? this.status,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'positionId': positionId,
      'departmentId': departmentId,
      'address': address,
      'phone': phone,
      'email': email,
      'date': date,
      'status': status,
      'avatar': avatar,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory PersionalManagement.fromMap(Map<String, dynamic> map) {
    return PersionalManagement(
      id: map['id'] as String?,
      code: map['code'] ?? '',
      name: map['name'] ?? '',
      dateOfBirth: map['dateOfBirth'] ?? '',
      gender: map['gender'] ?? '',
      positionId: map['positionId'],
      departmentId: map['departmentId'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      date: map['date'] ?? '',
      avatar: map['avatar'] ?? '',
      status: map['status'] ?? '',
      createdAt:
          map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,
    );
  }

  String toJson() => toMap().toString();

  factory PersionalManagement.fromJson(Map<String, dynamic> json) =>
      PersionalManagement.fromMap(json);
}
