
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? country;
  final String? gender;
  final DateTime? birthday;
  final String? birthPlace;
  final bool verified;
  final bool allInfo;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.country,
    this.gender,
    this.birthday,
    this.birthPlace,
    required this.verified,
    required this.allInfo,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'],
      country: json['country'],
      gender: json['gender'],
      birthday: json['birthday'] != null 
          ? DateTime.parse(json['birthday']) 
          : null,
      birthPlace: json['birthPlace'],
      verified: json['verified'] ?? false,
      allInfo: json['allInfo'] ?? false,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'country': country,
      'gender': gender,
      'birthday': birthday?.toIso8601String(),
      'birthPlace': birthPlace,
      'verified': verified,
      'allInfo': allInfo,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? country,
    String? gender,
    DateTime? birthday,
    String? birthPlace,
    bool? verified,
    bool? allInfo,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      birthPlace: birthPlace ?? this.birthPlace,
      verified: verified ?? this.verified,
      allInfo: allInfo ?? this.allInfo,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}