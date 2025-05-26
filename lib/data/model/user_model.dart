class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String avatarUrl;
  final String phone;
  final String bio;
  final String role;
  final String token;

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.avatarUrl,
    required this.phone,
    required this.bio,
    required this.role,
    required this.token,
  });

  factory AppUser.fromMap(
    Map<String, dynamic> map, {
    required String uid,
    required String token,
  }) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      phone: map['phone'] ?? '',
      bio: map['bio'] ?? '',
      role: map['role'] ?? 'user',
      token: token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role,
      'token': token,
      'bio': bio,
      'phone': phone,
    };
  }
}
