class Program {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String? imageUrl;
  final double price;
  final double? discountPrice;
  final int duration; // in months
  final String level; // 'beginner', 'intermediate', 'advanced'
  final bool isActive;
  final bool isFeatured;
  final int enrolledCount;
  final double rating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> courseIds;
  final List<String> tags;
  final ProgramRequirements requirements;

  Program({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    this.imageUrl,
    required this.price,
    this.discountPrice,
    required this.duration,
    required this.level,
    required this.isActive,
    required this.isFeatured,
    required this.enrolledCount,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.courseIds,
    required this.tags,
    required this.requirements,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? '',
      imageUrl: json['imageUrl'],
      price: (json['price'] ?? 0).toDouble(),
      discountPrice: json['discountPrice']?.toDouble(),
      duration: json['duration'] ?? 0,
      level: json['level'] ?? 'beginner',
      isActive: json['isActive'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      enrolledCount: json['enrolledCount'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      courseIds: List<String>.from(json['courseIds'] ?? []),
      tags: List<String>.from(json['tags'] ?? []),
      requirements: ProgramRequirements.fromJson(json['requirements'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
      'price': price,
      'discountPrice': discountPrice,
      'duration': duration,
      'level': level,
      'isActive': isActive,
      'isFeatured': isFeatured,
      'enrolledCount': enrolledCount,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'courseIds': courseIds,
      'tags': tags,
      'requirements': requirements.toJson(),
    };
  }
}

class ProgramRequirements {
  final String? education;
  final String? experience;
  final List<String> skills;
  final String? notes;

  ProgramRequirements({
    this.education,
    this.experience,
    required this.skills,
    this.notes,
  });

  factory ProgramRequirements.fromJson(Map<String, dynamic> json) {
    return ProgramRequirements(
      education: json['education'],
      experience: json['experience'],
      skills: List<String>.from(json['skills'] ?? []),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'education': education,
      'experience': experience,
      'skills': skills,
      'notes': notes,
    };
  }
}
