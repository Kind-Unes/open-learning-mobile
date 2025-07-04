class Exam {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final String programId;
  final int duration; // in minutes
  final int totalQuestions;
  final int passingScore;
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Question> questions;

  Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.programId,
    required this.duration,
    required this.totalQuestions,
    required this.passingScore,
    required this.isActive,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      courseId: json['courseId'] ?? '',
      programId: json['programId'] ?? '',
      duration: json['duration'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      passingScore: json['passingScore'] ?? 0,
      isActive: json['isActive'] ?? true,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      questions:
          (json['questions'] as List?)
              ?.map((q) => Question.fromJson(q))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'courseId': courseId,
      'programId': programId,
      'duration': duration,
      'totalQuestions': totalQuestions,
      'passingScore': passingScore,
      'isActive': isActive,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}

class Question {
  final String id;
  final String questionText;
  final List<String> options;
  final int correctAnswer;
  final int marks;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.marks,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] ?? '',
      questionText: json['questionText'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? 0,
      marks: json['marks'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
      'marks': marks,
    };
  }
}
