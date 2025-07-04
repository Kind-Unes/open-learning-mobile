class Promo {
  final String id;
  final String title;
  final String description;
  final String code;
  final String type; // 'percentage' or 'fixed'
  final double value;
  final double? minAmount;
  final double? maxDiscount;
  final int usageLimit;
  final int usedCount;
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> applicableCourses;
  final List<String> applicablePrograms;

  Promo({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.type,
    required this.value,
    this.minAmount,
    this.maxDiscount,
    required this.usageLimit,
    required this.usedCount,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.applicableCourses,
    required this.applicablePrograms,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      code: json['code'] ?? '',
      type: json['type'] ?? 'percentage',
      value: (json['value'] ?? 0).toDouble(),
      minAmount: json['minAmount']?.toDouble(),
      maxDiscount: json['maxDiscount']?.toDouble(),
      usageLimit: json['usageLimit'] ?? 0,
      usedCount: json['usedCount'] ?? 0,
      isActive: json['isActive'] ?? true,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      applicableCourses: List<String>.from(json['applicableCourses'] ?? []),
      applicablePrograms: List<String>.from(json['applicablePrograms'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'code': code,
      'type': type,
      'value': value,
      'minAmount': minAmount,
      'maxDiscount': maxDiscount,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'isActive': isActive,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'applicableCourses': applicableCourses,
      'applicablePrograms': applicablePrograms,
    };
  }
}
