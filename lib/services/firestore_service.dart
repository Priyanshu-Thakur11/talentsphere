import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/project_model.dart';
import '../models/team_model.dart';
import '../models/payment_model.dart';
import '../models/notification_model.dart';
import '../models/chat_model.dart';
import 'firebase_service.dart';

class FirestoreService {
  static FirestoreService? _instance;
  static FirestoreService get instance {
    _instance ??= FirestoreService._();
    return _instance!;
  }

  FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

  Future<String> createReview(ReviewModel review) async {
    try {
      final docRef = await _firestore
          .collection('reviews') // Assuming you use the 'reviews' collection
          .add(review.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create review: $e');
    }
  }

  Future<List<ReviewModel>> getReviewsForUser(String userId, ReviewTarget targetRole, {int limit = 20}) async {
    try {
      final snapshot = await _firestore
          .collection('reviews')
          .where('receiverId', isEqualTo: userId)
          .where('receiverRole', isEqualTo: targetRole.toString().split('.').last)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs
          .map((doc) => ReviewModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get reviews for user: $e');
    }
  }

  // User operations
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .set(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .update(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<List<UserModel>> getUsers({
    UserRole? role,
    int limit = 20,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      Query query = _firestore.collection('users');
      
      if (role != null) {
        query = query.where('role', isEqualTo: role.toString().split('.').last);
      }
      
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }
      
      query = query.limit(limit);
      
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  // Project operations
  Future<String> createProject(ProjectModel project) async {
    try {
      final docRef = await _firestore
          .collection('projects')
          .add(project.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create project: $e');
    }
  }

  Future<ProjectModel?> getProject(String projectId) async {
    try {
      final doc = await _firestore
          .collection('projects')
          .doc(projectId)
          .get();
      
      if (doc.exists) {
        return ProjectModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get project: $e');
    }
  }

  Future<void> updateProject(ProjectModel project) async {
    try {
      await _firestore
          .collection('projects')
          .doc(project.id)
          .update(project.toFirestore());
    } catch (e) {
      throw Exception('Failed to update project: $e');
    }
  }

  Future<List<ProjectModel>> getProjects({
    String? clientId,
    String? freelancerId,
    ProjectStatus? status,
    int limit = 20,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      Query query = _firestore.collection('projects');
      
      if (clientId != null) {
        query = query.where('clientId', isEqualTo: clientId);
      }
      
      if (freelancerId != null) {
        query = query.where('freelancerId', isEqualTo: freelancerId);
      }
      
      if (status != null) {
        query = query.where('status', isEqualTo: status.toString().split('.').last);
      }
      
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }
      
      query = query.limit(limit).orderBy('createdAt', descending: true);
      
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => ProjectModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get projects: $e');
    }
  }

  // Team operations
  Future<String> createTeam(TeamModel team) async {
    try {
      final docRef = await _firestore
          .collection('teams')
          .add(team.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create team: $e');
    }
  }

  Future<TeamModel?> getTeam(String teamId) async {
    try {
      final doc = await _firestore
          .collection('teams')
          .doc(teamId)
          .get();
      
      if (doc.exists) {
        return TeamModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get team: $e');
    }
  }

  Future<void> updateTeam(TeamModel team) async {
    try {
      await _firestore
          .collection('teams')
          .doc(team.id)
          .update(team.toFirestore());
    } catch (e) {
      throw Exception('Failed to update team: $e');
    }
  }

  Future<List<TeamModel>> getTeams({
    String? leaderId,
    TeamStatus? status,
    int limit = 20,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      Query query = _firestore.collection('teams');
      
      if (leaderId != null) {
        query = query.where('leaderId', isEqualTo: leaderId);
      }
      
      if (status != null) {
        query = query.where('status', isEqualTo: status.toString().split('.').last);
      }
      
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }
      
      query = query.limit(limit).orderBy('createdAt', descending: true);
      
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => TeamModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get teams: $e');
    }
  }

  // Payment operations
  Future<String> createPayment(PaymentModel payment) async {
    try {
      final docRef = await _firestore
          .collection('payments')
          .add(payment.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  Future<PaymentModel?> getPayment(String paymentId) async {
    try {
      final doc = await _firestore
          .collection('payments')
          .doc(paymentId)
          .get();
      
      if (doc.exists) {
        return PaymentModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get payment: $e');
    }
  }

  Future<void> updatePayment(PaymentModel payment) async {
    try {
      await _firestore
          .collection('payments')
          .doc(payment.id)
          .update(payment.toFirestore());
    } catch (e) {
      throw Exception('Failed to update payment: $e');
    }
  }

  Future<List<PaymentModel>> getPayments({
    String? userId,
    PaymentStatus? status,
    int limit = 20,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      Query query = _firestore.collection('payments');
      
      if (userId != null) {
        query = query.where('toUserId', isEqualTo: userId);
      }
      
      if (status != null) {
        query = query.where('status', isEqualTo: status.toString().split('.').last);
      }
      
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }
      
      query = query.limit(limit).orderBy('createdAt', descending: true);
      
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => PaymentModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get payments: $e');
    }
  }

  // Notification operations
  Future<String> createNotification(NotificationModel notification) async {
    try {
      final docRef = await _firestore
          .collection('notifications')
          .add(notification.toFirestore());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  Future<List<NotificationModel>> getNotifications({
    required String userId,
    bool? isRead,
    int limit = 20,
    DocumentSnapshot? lastDoc,
  }) async {
    try {
      Query query = _firestore
          .collection('notifications')
          .where('userId', isEqualTo: userId);
      
      if (isRead != null) {
        query = query.where('isRead', isEqualTo: isRead);
      }
      
      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc);
      }
      
      query = query.limit(limit).orderBy('createdAt', descending: true);
      
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => NotificationModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({
        'isRead': true,
        'readAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  // Search operations
  Future<List<ProjectModel>> searchProjects({
    String? query,
    List<String>? skills,
    double? minBudget,
    double? maxBudget,
    int limit = 20,
  }) async {
    try {
      Query firestoreQuery = _firestore.collection('projects');
      
      if (skills != null && skills.isNotEmpty) {
        firestoreQuery = firestoreQuery.where('requiredSkills', arrayContainsAny: skills);
      }
      
      if (minBudget != null) {
        firestoreQuery = firestoreQuery.where('budget', isGreaterThanOrEqualTo: minBudget);
      }
      
      if (maxBudget != null) {
        firestoreQuery = firestoreQuery.where('budget', isLessThanOrEqualTo: maxBudget);
      }
      
      firestoreQuery = firestoreQuery.limit(limit).orderBy('createdAt', descending: true);
      
      final snapshot = await firestoreQuery.get();
      List<ProjectModel> projects = snapshot.docs
          .map((doc) => ProjectModel.fromFirestore(doc))
          .toList();
      
      // Client-side filtering for text search
      if (query != null && query.isNotEmpty) {
        projects = projects.where((project) {
          return project.title.toLowerCase().contains(query.toLowerCase()) ||
                 project.description.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
      
      return projects;
    } catch (e) {
      throw Exception('Failed to search projects: $e');
    }
  }

  // Real-time listeners
  Stream<List<ProjectModel>> listenToProjects({
    String? clientId,
    String? freelancerId,
    ProjectStatus? status,
  }) {
    Query query = _firestore.collection('projects');
    
    if (clientId != null) {
      query = query.where('clientId', isEqualTo: clientId);
    }
    
    if (freelancerId != null) {
      query = query.where('freelancerId', isEqualTo: freelancerId);
    }
    
    if (status != null) {
      query = query.where('status', isEqualTo: status.toString().split('.').last);
    }
    
    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProjectModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<NotificationModel>> listenToNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NotificationModel.fromFirestore(doc))
            .toList());
  }

  // Chat operations
  Future<String> getOrCreateChatRoom(String userId1, String userId2) async {
    try {
      // Check if chat room already exists
      final existingRooms = await _firestore
          .collection('chatRooms')
          .where('participants', arrayContains: userId1)
          .get();

      for (final doc in existingRooms.docs) {
        final data = doc.data();
        final participants = List<String>.from(data['participants'] ?? []);
        if (participants.contains(userId2)) {
          return doc.id;
        }
      }

      // Create new chat room
      final chatRoom = ChatRoomModel(
        id: '', // Will be generated by Firestore
        participants: [userId1, userId2],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final docRef = await _firestore
          .collection('chatRooms')
          .add(chatRoom.toFirestore());
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to get or create chat room: $e');
    }
  }

  Future<List<ChatRoomModel>> getUserChatRooms(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('chatRooms')
          .where('participants', arrayContains: userId)
          .get();
      
      // Sort in the app instead of Firestore to avoid needing a composite index
      final chatRooms = snapshot.docs
          .map((doc) => ChatRoomModel.fromFirestore(doc))
          .toList();
      
      // Sort by updatedAt (newest first)
      chatRooms.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      return chatRooms;
    } catch (e) {
      throw Exception('Failed to get user chat rooms: $e');
    }
  }

  Future<List<ChatModel>> getChatMessages(String chatRoomId) async {
    try {
      final snapshot = await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .get();
      
      return snapshot.docs
          .map((doc) => ChatModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get chat messages: $e');
    }
  }

  Future<void> sendMessage(String chatRoomId, ChatModel message) async {
    try {
      // Add message to chat room
      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toFirestore());

      // Update chat room with last message info
      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .update({
        'lastMessage': message.message,
        'lastMessageTime': Timestamp.fromDate(message.timestamp),
        'lastMessageSenderId': message.senderId,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Update unread count for receiver
      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .update({
        'unreadCounts.${message.receiverId}': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> markMessagesAsRead(String chatRoomId, String userId) async {
    try {
      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .update({
        'unreadCounts.$userId': 0,
      });
    } catch (e) {
      throw Exception('Failed to mark messages as read: $e');
    }
  }

  // Real-time chat listeners
  Stream<List<ChatModel>> listenToChatMessages(String chatRoomId) {
    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<ChatRoomModel>> listenToUserChatRooms(String userId) {
    return _firestore
        .collection('chatRooms')
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          final chatRooms = snapshot.docs
              .map((doc) => ChatRoomModel.fromFirestore(doc))
              .toList();
          
          // Sort in the app to avoid composite index requirement
          chatRooms.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          
          return chatRooms;
        });
  }
}
