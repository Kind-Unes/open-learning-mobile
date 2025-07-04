# OneSignal Push Notifications Setup Guide

This guide will help you set up OneSignal push notifications for the Open Learning Academy app.

## Prerequisites

1. OneSignal account (free at https://onesignal.com)
2. Firebase project (for Android FCM configuration)
3. Android Studio or VS Code with Flutter extension

## OneSignal Configuration

### 1. Create OneSignal App

1. Go to https://onesignal.com and create an account
2. Create a new app and choose "Android" as the platform
3. Configure Google Android (FCM) by providing your Firebase Server Key and Sender ID

### 2. Get Your App ID

1. In your OneSignal dashboard, go to Settings → Keys & IDs
2. Copy your OneSignal App ID
3. Replace `your_onesignal_app_id_here` in the `.env` file with your actual App ID

### 3. Firebase Configuration

1. Go to Firebase Console (https://console.firebase.google.com)
2. Create a new project or use existing one
3. Add an Android app to your project
4. Use package name: `com.hellaletyounes.openlearning`
5. Download `google-services.json` and place it in `android/app/`

### 4. Add Firebase to Android

Add the following to your `android/app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Add this line
}

dependencies {
    implementation("com.google.firebase:firebase-messaging:23.4.0") // Add this line
}
```

Add to `android/build.gradle.kts`:

```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0") // Add this line
    }
}
```

## Environment Variables

Update your `.env` file with your OneSignal App ID:

```properties
BASE_URL=https://your-api-url.com/api
ONESIGNAL_APP_ID=your_onesignal_app_id_here
```

## Usage

### Basic Setup

The notification service is automatically initialized in `main.dart`. No additional setup is required.

### User Authentication Integration

When a user logs in, set their external user ID:

```dart
await NotificationManager.instance.initializeForUser(userId);
```

### Student Setup

```dart
await NotificationManager.instance.setupStudentNotifications(
  studentId: 'student123',
  grade: 'high_school',
  subjects: ['math', 'science', 'english'],
);
```

### Teacher Setup

```dart
await NotificationManager.instance.setupTeacherNotifications(
  teacherId: 'teacher456',
  subjects: ['math', 'physics'],
  grades: ['grade_10', 'grade_11'],
);
```

### Course Subscription

```dart
// Subscribe to course notifications
await NotificationManager.instance.subscribeToCourse('course_123');

// Unsubscribe from course notifications
await NotificationManager.instance.unsubscribeFromCourse('course_123');
```

### Notification Preferences

```dart
await NotificationManager.instance.updateNotificationPreferences(
  enableCourseNotifications: true,
  enableProgramNotifications: true,
  enableAnnouncementNotifications: false,
  enableChatNotifications: true,
);
```

### Logout

```dart
await NotificationManager.instance.handleUserLogout();
```

## Notification Types

The app supports the following notification types:

- **course**: Navigate to specific course
- **program**: Navigate to specific program
- **announcement**: Navigate to announcements
- **chat**: Navigate to chat/messaging

## Testing

Use the `NotificationTestScreen` to test notification functionality:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const NotificationTestScreen(),
  ),
);
```

## Sending Notifications

### From OneSignal Dashboard

1. Go to OneSignal Dashboard → Messages
2. Create a new push notification
3. Target users by tags (e.g., `user_type` = `student`)
4. Add additional data for deep linking

### From Backend API

Use OneSignal REST API to send notifications from your backend:

```http
POST https://onesignal.com/api/v1/notifications
Content-Type: application/json; charset=utf-8
Authorization: Basic YOUR_REST_API_KEY

{
  "app_id": "your_app_id",
  "filters": [
    {"field": "tag", "key": "user_type", "relation": "=", "value": "student"}
  ],
  "headings": {"en": "New Course Available", "ar": "دورة جديدة متاحة"},
  "contents": {"en": "Check out the new Math course", "ar": "تحقق من دورة الرياضيات الجديدة"},
  "data": {
    "type": "course",
    "target_id": "course_123"
  }
}
```

## Troubleshooting

### Common Issues

1. **Notifications not received**: Check if permissions are granted
2. **App crashes on initialization**: Verify OneSignal App ID is correct
3. **Firebase integration issues**: Ensure `google-services.json` is in the correct location

### Debug Mode

Enable debug mode to see detailed logs:

```dart
OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
```

### Check Notification Status

```dart
bool isEnabled = await NotificationManager.instance.areNotificationsEnabled();
String? userId = await NotificationManager.instance.getCurrentUserId();
```

## Features Implemented

- ✅ OneSignal SDK integration
- ✅ Android configuration
- ✅ Foreground and background notification handling
- ✅ User targeting with tags
- ✅ Deep linking support
- ✅ Course and program subscriptions
- ✅ Notification preferences
- ✅ User authentication integration
- ✅ Test screen for debugging

## Next Steps

1. Add your OneSignal App ID to the `.env` file
2. Configure Firebase and download `google-services.json`
3. Test notifications using the test screen
4. Implement backend API for sending notifications
5. Add iOS support if needed

## Support

For issues or questions, refer to:

- [OneSignal Documentation](https://documentation.onesignal.com/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Documentation](https://flutter.dev/docs)
