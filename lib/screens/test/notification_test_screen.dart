import 'package:flutter/material.dart';
import 'package:open_learning/services/notification_service.dart';
import 'package:open_learning/theme/app_theme.dart';
import 'package:open_learning/theme/app_colors.dart';

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  String? _userId;
  bool _isNotificationEnabled = false;
  String _notificationStatus = 'Unknown';
  final List<String> _notificationLogs = [];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    // Get user ID
    final userId = await NotificationService.instance.getUserId();

    // Check notification status
    final isEnabled =
        await NotificationService.instance.isPushNotificationEnabled();

    // Setup custom notification handlers
    NotificationService.instance.setNotificationHandlers(
      onReceived: (message) {
        _addLog('Notification received: $message');
      },
      onClicked: (event) {
        _addLog('Notification clicked: ${event.notification.title}');
        _showNotificationDialog(
          'Notification Clicked',
          'Title: ${event.notification.title}\nBody: ${event.notification.body}',
        );
      },
      onWillDisplay: (event) {
        _addLog('Notification will display: ${event.notification.title}');
      },
    );

    setState(() {
      _userId = userId;
      _isNotificationEnabled = isEnabled;
      _notificationStatus = isEnabled ? 'Enabled' : 'Disabled';
    });
  }

  void _addLog(String message) {
    setState(() {
      _notificationLogs.insert(
        0,
        '${DateTime.now().toIso8601String()}: $message',
      );
      if (_notificationLogs.length > 20) {
        _notificationLogs.removeLast();
      }
    });
  }

  void _showNotificationDialog(String title, String content) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Test'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const SizedBox(height: 16),
            _buildTagsSection(),
            const SizedBox(height: 16),
            _buildLogsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notification Info', style: AppTheme.headline),
            const SizedBox(height: 8),
            Text(
              'User ID: ${_userId ?? 'Not available'}',
              style: AppTheme.body,
            ),
            const SizedBox(height: 4),
            Text(
              'Status: $_notificationStatus',
              style: AppTheme.body.copyWith(
                color:
                    _isNotificationEnabled
                        ? AppColors.primary
                        : AppColors.textOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Actions', style: AppTheme.headline),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final permission =
                        await NotificationService.instance
                            .requestNotificationPermission();
                    _addLog('Permission requested: $permission');
                    await _initializeNotifications();
                  },
                  child: const Text('Request Permission'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await NotificationService.instance.setExternalUserId(
                      'user_123',
                    );
                    _addLog('External user ID set: user_123');
                    await _initializeNotifications();
                  },
                  child: const Text('Set User ID'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await NotificationService.instance.removeExternalUserId();
                    _addLog('External user ID removed');
                    await _initializeNotifications();
                  },
                  child: const Text('Remove User ID'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await NotificationService.instance.clearAllNotifications();
                    _addLog('All notifications cleared');
                  },
                  child: const Text('Clear All'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tags Management', style: AppTheme.headline),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await NotificationService.instance.addTags({
                      'user_type': 'student',
                      'grade': 'high_school',
                      'language': 'ar',
                    });
                    _addLog('Student tags added');
                  },
                  child: const Text('Add Student Tags'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await NotificationService.instance.addTags({
                      'user_type': 'teacher',
                      'subject': 'mathematics',
                      'language': 'ar',
                    });
                    _addLog('Teacher tags added');
                  },
                  child: const Text('Add Teacher Tags'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await NotificationService.instance.removeTags([
                      'user_type',
                      'grade',
                      'subject',
                    ]);
                    _addLog('Tags removed');
                  },
                  child: const Text('Remove Tags'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notification Logs', style: AppTheme.headline),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _notificationLogs.clear();
                    });
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child:
                  _notificationLogs.isEmpty
                      ? Center(
                        child: Text('No logs yet', style: AppTheme.caption),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _notificationLogs.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              _notificationLogs[index],
                              style: AppTheme.caption,
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
