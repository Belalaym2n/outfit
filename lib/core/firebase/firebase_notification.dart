import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graduation_proj/config/routes/app_router.dart';
import 'package:graduation_proj/core/utils/app_colors.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  GlobalKey<ScaffoldMessengerState>? _scaffoldMessengerKey;
  GlobalKey<NavigatorState>? _navigatorKey;

  // Initialize with keys
  void initialize({
    required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
    required GlobalKey<NavigatorState> navigatorKey,
  }) {
    _scaffoldMessengerKey = scaffoldMessengerKey;
    _navigatorKey = navigatorKey;
  }

  //


  void setupListeners() {
    // 1️⃣ Foreground messages (when app is open)
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 2️⃣ When user taps notification (app in background)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // 3️⃣ When user taps notification (app was terminated)
    _handleInitialMessage();
  }

  // Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('🔔 Foreground Message Received:');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    _showInAppNotification(message);
  }

  // Handle notification tap from background
  void _handleNotificationTap(RemoteMessage message) {
    debugPrint('🔔 Notification Tapped (App in Background):');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Data: ${message.data}');

    _navigateBasedOnData(message.data);
  }

  // Handle initial message when app was terminated
  Future<void> _handleInitialMessage() async {
    final RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      debugPrint('🔔 Notification Tapped (App was Terminated):');
      debugPrint('Title: ${message.notification?.title}');
      debugPrint('Data: ${message.data}');

      // Delay navigation to ensure app is fully initialized
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigateBasedOnData(message.data);
      });
    }
  }

  // Show professional in-app notification
  void _showInAppNotification(RemoteMessage message) {
    final title = message.notification?.title ?? 'New Notification';
    final body = message.notification?.body ?? '';

    _scaffoldMessengerKey?.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.notifications_active,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (body.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),

        duration: const Duration(seconds: 55554),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryColor ,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
      ),
    );
  }

  // Navigate based on notification data
  void _navigateBasedOnData(Map<String, dynamic> data) {


    _navigateToRoute();
  }

   void _navigateToNotificationDetails(String id, Map<String, dynamic> data) {
    final context = _navigatorKey?.currentContext;

    if (context != null) {
      // Create NotificationModel from the data
      final notificationModel = NotificationModel(
        id: id,
        title: data['title']?.toString() ?? 'Notification',
        body: data['body']?.toString() ?? '',
        type: data['type']?.toString() ?? 'general',
        timestamp: DateTime.now(),
        isRead: false,
        data: data,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationDetailed(
            notificationModel: notificationModel,
          ),
        ),
      );
    } else {
      debugPrint('❌ Navigator context is null, cannot navigate to notification details');
    }
  }

  // Navigate to a route
  void _navigateToRoute(  {Object? arguments}) {
    final context = _navigatorKey?.currentContext;

    if (context != null) {
      Navigator.pushNamed(context, AppRoutes.notification, arguments: arguments);
    } else {
      debugPrint('❌ Navigator context is null, cannot navigate to ');
    }
  }

  // Subscribe to token refresh
  void subscribeToTokenRefresh(Function(String) onTokenRefresh) {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      debugPrint('🔄 Token refreshed: $newToken');
      onTokenRefresh(newToken);
    });
  }

  // Request notification permissions
  Future<bool> requestPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ User granted notification permission');
        return true;
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('⚠️ User granted provisional permission');
        return true;
      } else {
        debugPrint('❌ User declined notification permission');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error requesting permission: $e');
      return false;
    }
  }
}

// NotificationModel class
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic> data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    required this.isRead,
    required this.data,
  });
}

// NotificationDetailed screen (import this in your notification_detailed.dart file)
class NotificationDetailed extends StatefulWidget {
  final NotificationModel notificationModel;

  const NotificationDetailed({super.key, required this.notificationModel});

  @override
  State<NotificationDetailed> createState() => _NotificationDetailedState();
}

class _NotificationDetailedState extends State<NotificationDetailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              widget.notificationModel.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Timestamp
            Text(
              _formatTimestamp(widget.notificationModel.timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
            const Divider(height: 32),
            // Body
            Text(
              widget.notificationModel.body,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            // Additional data if available
            if (widget.notificationModel.data.isNotEmpty) ...[
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Additional Information',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...widget.notificationModel.data.entries.map(
                    (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}: ',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Expanded(
                        child: Text(entry.value.toString()),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}