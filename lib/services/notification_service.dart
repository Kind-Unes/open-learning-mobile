import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static NotificationService get instance => _instance;

  NotificationService._internal();

  // Notification callbacks
  Function(OSNotificationWillDisplayEvent)? onNotificationWillDisplay;
  Function(OSNotificationClickEvent)? onNotificationClicked;
  Function(String)? onNotificationReceived;

  /// Initialize OneSignal
  Future<void> initialize() async {
    try {
      final String? appId = dotenv.env['ONESIGNAL_APP_ID'];

      if (appId == null ||
          appId.isEmpty ||
          appId == 'your_onesignal_app_id_here') {
        log(
          'OneSignal App ID not found in .env file. Please add ONESIGNAL_APP_ID to your .env file.',
        );
        return;
      }

      // Initialize OneSignal
      OneSignal.initialize(appId);

      // Request notification permissions
      await requestNotificationPermission();

      // Set up notification handlers
      _setupNotificationHandlers();

      // Set external user ID if user is logged in
      await _setExternalUserIdIfAvailable();

      log('OneSignal initialized successfully');
    } catch (e) {
      log('Error initializing OneSignal: $e');
    }
  }

  /// Request notification permission
  Future<bool> requestNotificationPermission() async {
    try {
      final bool permission = await OneSignal.Notifications.requestPermission(
        true,
      );
      log('Notification permission granted: $permission');
      return permission;
    } catch (e) {
      log('Error requesting notification permission: $e');
      return false;
    }
  }

  /// Setup notification handlers
  void _setupNotificationHandlers() {
    // Handle notification received (when app is in foreground)
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      log('Notification received in foreground: ${event.notification.title}');

      // Call custom callback if provided
      onNotificationWillDisplay?.call(event);

      // Display the notification
      event.notification.display();
    });

    // Handle notification clicked
    OneSignal.Notifications.addClickListener((event) {
      log('Notification clicked: ${event.notification.title}');

      // Call custom callback if provided
      onNotificationClicked?.call(event);

      // Handle notification click action
      _handleNotificationClick(event);
    });

    // Handle notification permission changes
    OneSignal.Notifications.addPermissionObserver((state) {
      log('Notification permission changed: $state');
    });
  }

  /// Handle notification click actions
  void _handleNotificationClick(OSNotificationClickEvent event) {
    final additionalData = event.notification.additionalData;

    if (additionalData != null) {
      // Handle different notification types based on additional data
      final String? type = additionalData['type'];
      final String? targetId = additionalData['target_id'];

      switch (type) {
        case 'course':
          _navigateToCourse(targetId);
          break;
        case 'program':
          _navigateToProgram(targetId);
          break;
        case 'announcement':
          _navigateToAnnouncement(targetId);
          break;
        case 'chat':
          _navigateToChat(targetId);
          break;
        default:
          log('Unknown notification type: $type');
      }
    }
  }

  /// Navigate to course
  void _navigateToCourse(String? courseId) {
    if (courseId != null) {
      log('Navigating to course: $courseId');
      // TODO: Implement navigation to course screen
    }
  }

  /// Navigate to program
  void _navigateToProgram(String? programId) {
    if (programId != null) {
      log('Navigating to program: $programId');
      // TODO: Implement navigation to program screen
    }
  }

  /// Navigate to announcement
  void _navigateToAnnouncement(String? announcementId) {
    if (announcementId != null) {
      log('Navigating to announcement: $announcementId');
      // TODO: Implement navigation to announcement screen
    }
  }

  /// Navigate to chat
  void _navigateToChat(String? chatId) {
    if (chatId != null) {
      log('Navigating to chat: $chatId');
      // TODO: Implement navigation to chat screen
    }
  }

  /// Set external user ID (usually after user login)
  Future<void> setExternalUserId(String userId) async {
    try {
      await OneSignal.login(userId);

      // Store user ID in shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('onesignal_user_id', userId);

      log('External user ID set: $userId');
    } catch (e) {
      log('Error setting external user ID: $e');
    }
  }

  /// Set external user ID if available in storage
  Future<void> _setExternalUserIdIfAvailable() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString('onesignal_user_id');

      if (userId != null) {
        await OneSignal.login(userId);
        log('External user ID restored: $userId');
      }
    } catch (e) {
      log('Error restoring external user ID: $e');
    }
  }

  /// Remove external user ID (usually after user logout)
  Future<void> removeExternalUserId() async {
    try {
      await OneSignal.logout();

      // Remove user ID from shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('onesignal_user_id');

      log('External user ID removed');
    } catch (e) {
      log('Error removing external user ID: $e');
    }
  }

  /// Add tags to user
  Future<void> addTags(Map<String, String> tags) async {
    try {
      await OneSignal.User.addTags(tags);
      log('Tags added: $tags');
    } catch (e) {
      log('Error adding tags: $e');
    }
  }

  /// Remove tags from user
  Future<void> removeTags(List<String> tagKeys) async {
    try {
      await OneSignal.User.removeTags(tagKeys);
      log('Tags removed: $tagKeys');
    } catch (e) {
      log('Error removing tags: $e');
    }
  }

  /// Get subscription state
  Future<String?> getSubscriptionState() async {
    try {
      final state = await OneSignal.User.getOnesignalId();
      log('Subscription state: $state');
      return state;
    } catch (e) {
      log('Error getting subscription state: $e');
      return null;
    }
  }

  /// Get user ID
  Future<String?> getUserId() async {
    try {
      final userId = await OneSignal.User.getOnesignalId();
      log('User ID: $userId');
      return userId;
    } catch (e) {
      log('Error getting user ID: $e');
      return null;
    }
  }

  /// Send notification to specific user
  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String message,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      log('Sending notification to user: $userId');
      log('Title: $title');
      log('Message: $message');
      log('Additional data: $additionalData');

      // Note: This would typically be done from your backend server
      // OneSignal REST API call should be made from server-side
      log(
        'Note: Notification sending should be implemented on the server-side using OneSignal REST API',
      );
    } catch (e) {
      log('Error sending notification: $e');
    }
  }

  /// Send notification to all users with specific tags
  Future<void> sendNotificationToTags({
    required Map<String, String> tags,
    required String title,
    required String message,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      log('Sending notification to tags: $tags');
      log('Title: $title');
      log('Message: $message');
      log('Additional data: $additionalData');

      // Note: This would typically be done from your backend server
      // OneSignal REST API call should be made from server-side
      log(
        'Note: Notification sending should be implemented on the server-side using OneSignal REST API',
      );
    } catch (e) {
      log('Error sending notification: $e');
    }
  }

  /// Enable/disable push notifications
  Future<void> setPushNotificationEnabled(bool enabled) async {
    try {
      await OneSignal.User.pushSubscription.optIn();
      log('Push notifications enabled: $enabled');
    } catch (e) {
      log('Error setting push notification state: $e');
    }
  }

  /// Check if push notifications are enabled
  Future<bool> isPushNotificationEnabled() async {
    try {
      final state = OneSignal.User.pushSubscription.optedIn;
      log('Push notifications enabled: $state');
      return state ?? false;
    } catch (e) {
      log('Error checking push notification state: $e');
      return false;
    }
  }

  /// Set notification categories (for iOS)
  void setNotificationCategories(List<String> categories) {
    // This is primarily for iOS, but we can set it up for future use
    log('Setting notification categories: ${categories.length}');
  }

  /// Show local notification (for testing)
  void showLocalNotification({
    required String title,
    required String message,
    Map<String, dynamic>? additionalData,
  }) {
    log('Showing local notification');
    log('Title: $title');
    log('Message: $message');
    log('Additional data: $additionalData');

    // This would typically use a local notification plugin
    // For now, we'll just log the notification
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      await OneSignal.Notifications.clearAll();
      log('All notifications cleared');
    } catch (e) {
      log('Error clearing notifications: $e');
    }
  }

  /// Set custom notification handlers
  void setNotificationHandlers({
    Function(String)? onReceived,
    Function(OSNotificationClickEvent)? onClicked,
    Function(OSNotificationWillDisplayEvent)? onWillDisplay,
  }) {
    onNotificationReceived = onReceived;
    onNotificationClicked = onClicked;
    onNotificationWillDisplay = onWillDisplay;
  }

  /// Get notification history
  Future<List<OSNotification>> getNotificationHistory() async {
    try {
      // OneSignal doesn't provide a direct method to get history
      // You would need to implement this on your backend
      log('Getting notification history (implement on backend)');
      return [];
    } catch (e) {
      log('Error getting notification history: $e');
      return [];
    }
  }

  /// Set language
  Future<void> setLanguage(String languageCode) async {
    try {
      await OneSignal.User.setLanguage(languageCode);
      log('Language set to: $languageCode');
    } catch (e) {
      log('Error setting language: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    log('NotificationService disposed');
  }
}

/// Extension for easy access to notification service
extension NotificationServiceExtension on BuildContext {
  NotificationService get notifications => NotificationService.instance;
}
