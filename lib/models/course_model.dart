class Course {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String teacherId;
  final String? imageUrl;
  final String? videoUrl;
  final double price;
  final double? discountPrice;
  final int duration; // in hours
  final String level; // 'beginner', 'intermediate', 'advanced'
  final bool isActive;
  final bool isFeatured;
  final int enrolledCount;
  final double rating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Lesson> lessons;
  final List<String> tags;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.teacherId,
    this.imageUrl,
    this.videoUrl,
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
    required this.lessons,
    required this.tags,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      categoryId: json['categoryId'] ?? '',
      teacherId: json['teacherId'] ?? '',
      imageUrl: json['imageUrl'],
      videoUrl: json['videoUrl'],
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
      lessons:
          (json['lessons'] as List?)?.map((l) => Lesson.fromJson(l)).toList() ??
          [],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'teacherId': teacherId,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
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
      'lessons': lessons.map((l) => l.toJson()).toList(),
      'tags': tags,
    };
  }
}

class Lesson {
  final String id;
  final String title;
  final String description;
  final String? videoUrl;
  final int duration; // in minutes
  final int order;
  final bool isActive;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    this.videoUrl,
    required this.duration,
    required this.order,
    required this.isActive,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      videoUrl: json['videoUrl'],
      duration: json['duration'] ?? 0,
      order: json['order'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'videoUrl': videoUrl,
      'duration': duration,
      'order': order,
      'isActive': isActive,
    };
  }
}
