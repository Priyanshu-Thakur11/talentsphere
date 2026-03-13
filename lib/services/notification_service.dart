import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/notification_model.dart';
import 'firestore_service.dart';

class NotificationService {
  static NotificationService? _instance;
  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  NotificationService._();

  final FirestoreService _firestoreService = FirestoreService.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> initialize() async {
    try {
      // Initialize local notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Request permission for local notifications
      await _requestPermission();

    } catch (e) {
      throw Exception('Failed to initialize notifications: $e');
    }
  }

  // Request notification permission
  Future<bool> _requestPermission() async {
    try {
      // For local notifications, we'll just return true
      // In a real app, you'd request permission here
      return true;
    } catch (e) {
      throw Exception('Failed to request notification permission: $e');
    }
  }

  // Simplified notification service without FCM

  // Send notification
  Future<String> sendNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    NotificationPriority priority = NotificationPriority.medium,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    String? senderId,
    String? senderName,
  }) async {
    try {
      final notification = NotificationModel(
        id: '',
        userId: userId,
        title: title,
        body: body,
        type: type,
        priority: priority,
        createdAt: DateTime.now(),
        data: data ?? {},
        imageUrl: imageUrl,
        actionUrl: actionUrl,
        senderId: senderId,
        senderName: senderName,
      );

      final notificationId = await _firestoreService.createNotification(notification);
      
      // Send local notification
      await _showLocalNotification(
        title: title,
        body: body,
        data: data ?? {},
      );

      return notificationId;
    } catch (e) {
      throw Exception('Failed to send notification: $e');
    }
  }

  // Send local notification (simplified)

  // Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    Map<String, dynamic> data = const {},
  }) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'talent_sphere_channel',
        'TalentSphere Notifications',
        channelDescription: 'Notifications for TalentSphere app',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        notificationDetails,
        payload: data.toString(),
      );
    } catch (e) {
      throw Exception('Failed to show local notification: $e');
    }
  }

  // Get notifications for user
  Future<List<NotificationModel>> getNotifications({
    required String userId,
    bool? isRead,
    int limit = 20,
  }) async {
    try {
      return await _firestoreService.getNotifications(
        userId: userId,
        isRead: isRead,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  // Mark notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestoreService.markNotificationAsRead(notificationId);
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead(String userId) async {
    try {
      final notifications = await getNotifications(userId: userId, isRead: false);
      for (final notification in notifications) {
        await markAsRead(notification.id);
      }
    } catch (e) {
      throw Exception('Failed to mark all notifications as read: $e');
    }
  }

  // Get unread count
  Future<int> getUnreadCount(String userId) async {
    try {
      final notifications = await getNotifications(userId: userId, isRead: false);
      return notifications.length;
    } catch (e) {
      throw Exception('Failed to get unread count: $e');
    }
  }

  // Listen to notifications
  Stream<List<NotificationModel>> listenToNotifications(String userId) {
    return _firestoreService.listenToNotifications(userId);
  }

  // Send project invite notification
  Future<String> sendProjectInviteNotification({
    required String freelancerId,
    required String projectId,
    required String projectTitle,
    required String clientName,
  }) async {
    return await sendNotification(
      userId: freelancerId,
      title: 'New Project Invitation',
      body: '$clientName invited you to work on "$projectTitle"',
      type: NotificationType.projectInvite,
      priority: NotificationPriority.high,
      data: {
        'projectId': projectId,
        'clientName': clientName,
      },
      actionUrl: '/project/$projectId',
    );
  }

  // Send milestone completed notification
  Future<String> sendMilestoneCompletedNotification({
    required String clientId,
    required String projectId,
    required String milestoneTitle,
    required String freelancerName,
  }) async {
    return await sendNotification(
      userId: clientId,
      title: 'Milestone Completed',
      body: '$freelancerName completed milestone: $milestoneTitle',
      type: NotificationType.milestoneCompleted,
      priority: NotificationPriority.medium,
      data: {
        'projectId': projectId,
        'milestoneTitle': milestoneTitle,
      },
      actionUrl: '/project/$projectId',
    );
  }

  // Send payment received notification
  Future<String> sendPaymentReceivedNotification({
    required String freelancerId,
    required double amount,
    required String projectTitle,
  }) async {
    return await sendNotification(
      userId: freelancerId,
      title: 'Payment Received',
      body: 'You received \$${amount.toStringAsFixed(2)} for "$projectTitle"',
      type: NotificationType.paymentReceived,
      priority: NotificationPriority.high,
      data: {
        'amount': amount,
        'projectTitle': projectTitle,
      },
    );
  }

  // Send team invite notification
  Future<String> sendTeamInviteNotification({
    required String userId,
    required String teamName,
    required String inviterName,
  }) async {
    return await sendNotification(
      userId: userId,
      title: 'Team Invitation',
      body: '$inviterName invited you to join "$teamName"',
      type: NotificationType.teamInvite,
      priority: NotificationPriority.medium,
      data: {
        'teamName': teamName,
        'inviterName': inviterName,
      },
    );
  }

  // Send chat notification
  Future<String> sendChatNotification({
    required String userId,
    required String senderName,
    required String message,
    String? chatRoomId,
  }) async {
    return await sendNotification(
      userId: userId,
      title: 'New Message from $senderName',
      body: message.length > 50 ? '${message.substring(0, 50)}...' : message,
      type: NotificationType.chat,
      priority: NotificationPriority.high,
      data: {
        'chatRoomId': chatRoomId,
        'senderName': senderName,
      },
      actionUrl: chatRoomId != null ? '/chat/$chatRoomId' : null,
    );
  }

  // Send project posted notification
  Future<String> sendProjectPostedNotification({
    required String userId,
    required String projectTitle,
    required String clientName,
    required String projectId,
  }) async {
    return await sendNotification(
      userId: userId,
      title: 'New Project Available',
      body: '$clientName posted a new project: "$projectTitle"',
      type: NotificationType.projectPosted,
      priority: NotificationPriority.medium,
      data: {
        'projectId': projectId,
        'projectTitle': projectTitle,
        'clientName': clientName,
      },
      actionUrl: '/project/$projectId',
    );
  }

  // Send freelancer joined notification
  Future<String> sendFreelancerJoinedNotification({
    required String userId,
    required String freelancerName,
  }) async {
    return await sendNotification(
      userId: userId,
      title: 'New Freelancer Joined',
      body: '$freelancerName has joined the platform',
      type: NotificationType.freelancerJoined,
      priority: NotificationPriority.low,
      data: {
        'freelancerName': freelancerName,
      },
    );
  }


  // Handle local notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle local notification tap
    final payload = response.payload;
    if (payload != null) {
      // Parse payload and navigate accordingly
    }
  }
}

