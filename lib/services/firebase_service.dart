import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../firebase_options.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  FirebaseService._();

  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  late FirebaseStorage _storage;

  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;
  FirebaseStorage get storage => _storage;

  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _storage = FirebaseStorage.instance;
  }

  // Collection references
  CollectionReference get users => _firestore.collection('users');
  CollectionReference get projects => _firestore.collection('projects');
  CollectionReference get teams => _firestore.collection('teams');
  CollectionReference get payments => _firestore.collection('payments');
  CollectionReference get notifications => _firestore.collection('notifications');
  CollectionReference get chats => _firestore.collection('chats');
  CollectionReference get proposals => _firestore.collection('proposals');
  CollectionReference get reviews => _firestore.collection('reviews');

  // Storage references
  Reference get storageRef => _storage.ref();
  Reference get profileImagesRef => _storage.ref('profile_images');
  Reference get projectFilesRef => _storage.ref('project_files');
  Reference get teamLogosRef => _storage.ref('team_logos');
  Reference get resumesRef => _storage.ref('resumes');

  // Batch operations
  WriteBatch batch() => _firestore.batch();

  // Transaction operations
  Future<T> runTransaction<T>(TransactionHandler<T> handler) {
    return _firestore.runTransaction(handler);
  }

  // Real-time listeners
  Stream<DocumentSnapshot> listenToDocument(String collection, String docId) {
    return _firestore.collection(collection).doc(docId).snapshots();
  }

  Stream<QuerySnapshot> listenToCollection(String collection, {
    Query Function(Query)? queryBuilder,
    int? limit,
  }) {
    Query query = _firestore.collection(collection);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    if (limit != null) {
      query = query.limit(limit);
    }
    return query.snapshots();
  }

  // Offline persistence
  Future<void> enableOfflinePersistence() async {
    await _firestore.enablePersistence();
  }

  // Security rules helpers
  Future<bool> isUserAuthorized(String userId, String resource) async {
    // Implement your authorization logic here
    // This is a placeholder - implement based on your security rules
    return true;
  }
}
