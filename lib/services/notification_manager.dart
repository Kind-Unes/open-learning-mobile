import 'dart:developer';

import 'package:open_learning/services/notification_service.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  static NotificationManager get instance => _instance;

  NotificationManager._internal();

  /// Initialize notifications for authenticated user
  Future<void> initializeForUser(String userId) async {
    try {
      // Set external user ID for OneSignal
      await NotificationService.instance.setExternalUserId(userId);

      // Add user-specific tags
      await NotificationService.instance.addTags({
        'user_id': userId,
        'platform': 'android',
        'language': 'ar',
      });

      log('Notifications initialized for user: $userId');
    } catch (e) {
      log('Error initializing notifications for user: $e');
    }
  }

  /// Setup student-specific notifications
  Future<void> setupStudentNotifications({
    required String studentId,
    required String grade,
    required List<String> subjects,
  }) async {
    try {
      await NotificationService.instance.addTags({
        'user_type': 'student',
        'student_id': studentId,
        'grade': grade,
        'subjects': subjects.join(','),
      });

      log('Student notifications setup completed');
    } catch (e) {
      log('Error setting up student notifications: $e');
    }
  }

  /// Setup teacher-specific notifications
  Future<void> setupTeacherNotifications({
    required String teacherId,
    required List<String> subjects,
    required List<String> grades,
  }) async {
    try {
      await NotificationService.instance.addTags({
        'user_type': 'teacher',
        'teacher_id': teacherId,
        'teaching_subjects': subjects.join(','),
        'teaching_grades': grades.join(','),
      });

      log('Teacher notifications setup completed');
    } catch (e) {
      log('Error setting up teacher notifications: $e');
    }
  }

  /// Handle user logout
  Future<void> handleUserLogout() async {
    try {
      await NotificationService.instance.removeExternalUserId();
      await NotificationService.instance.removeTags([
        'user_type',
        'user_id',
        'student_id',
        'teacher_id',
        'grade',
        'subjects',
        'teaching_subjects',
        'teaching_grades',
      ]);

      log('User logout handled for notifications');
    } catch (e) {
      log('Error handling logout for notifications: $e');
    }
  }

  /// Subscribe to course notifications
  Future<void> subscribeToCourse(String courseId) async {
    try {
      await NotificationService.instance.addTags({
        'course_$courseId': 'subscribed',
      });

      log('Subscribed to course notifications: $courseId');
    } catch (e) {
      log('Error subscribing to course notifications: $e');
    }
  }

  /// Unsubscribe from course notifications
  Future<void> unsubscribeFromCourse(String courseId) async {
    try {
      await NotificationService.instance.removeTags(['course_$courseId']);

      log('Unsubscribed from course notifications: $courseId');
    } catch (e) {
      log('Error unsubscribing from course notifications: $e');
    }
  }

  /// Subscribe to program notifications
  Future<void> subscribeToProgram(String programId) async {
    try {
      await NotificationService.instance.addTags({
        'program_$programId': 'subscribed',
      });

      log('Subscribed to program notifications: $programId');
    } catch (e) {
      log('Error subscribing to program notifications: $e');
    }
  }

  /// Unsubscribe from program notifications
  Future<void> unsubscribeFromProgram(String programId) async {
    try {
      await NotificationService.instance.removeTags(['program_$programId']);

      log('Unsubscribed from program notifications: $programId');
    } catch (e) {
      log('Error unsubscribing from program notifications: $e');
    }
  }

  /// Update notification preferences
  Future<void> updateNotificationPreferences({
    required bool enableCourseNotifications,
    required bool enableProgramNotifications,
    required bool enableAnnouncementNotifications,
    required bool enableChatNotifications,
  }) async {
    try {
      final preferences = <String, String>{
        'notif_courses': enableCourseNotifications ? 'enabled' : 'disabled',
        'notif_programs': enableProgramNotifications ? 'enabled' : 'disabled',
        'notif_announcements':
            enableAnnouncementNotifications ? 'enabled' : 'disabled',
        'notif_chat': enableChatNotifications ? 'enabled' : 'disabled',
      };

      await NotificationService.instance.addTags(preferences);

      log('Notification preferences updated');
    } catch (e) {
      log('Error updating notification preferences: $e');
    }
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    return await NotificationService.instance.isPushNotificationEnabled();
  }

  /// Request notification permissions
  Future<bool> requestNotificationPermissions() async {
    return await NotificationService.instance.requestNotificationPermission();
  }

  /// Get current user's OneSignal ID
  Future<String?> getCurrentUserId() async {
    return await NotificationService.instance.getUserId();
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    await NotificationService.instance.clearAllNotifications();
  }
}
