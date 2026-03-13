import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }

  AuthService._();

  final FirebaseAuth _auth = FirebaseService.instance.auth;
  final FirebaseFirestore _firestore = FirebaseService.instance.firestore;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    String? phoneNumber,
    String? bio,
    List<String> skills = const [],
    double? hourlyRate,
    String? location,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final userModel = UserModel(
          id: credential.user!.uid,
          email: email,
          name: name,
          role: role,
          phoneNumber: phoneNumber,
          bio: bio,
          skills: skills,
          hourlyRate: hourlyRate,
          location: location,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(userModel.toFirestore());

        await _saveUserToLocal(userModel);
      }

      return credential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign in with email and password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _loadUserFromFirestore(credential.user!.uid);
      }

      return credential;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign in with Google (simplified - requires google_sign_in package)
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // This would require the google_sign_in package
      // For now, we'll throw an error indicating the package is needed
      throw Exception('Google Sign-In requires google_sign_in package. Please add it to pubspec.yaml');
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _clearUserFromLocal();
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      await _firestore
          .collection('users')
          .doc(updatedUser.id)
          .update(updatedUser.toFirestore());
      
      await _saveUserToLocal(updatedUser);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUser() async {
    try {
      if (currentUser == null) return null;
      
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .get();

      if (userDoc.exists) {
        final userModel = UserModel.fromFirestore(userDoc);
        await _saveUserToLocal(userModel);
        return userModel;
      }
      return null;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Check if user is admin
  Future<bool> isAdmin() async {
    final user = await getCurrentUser();
    return user?.role == UserRole.admin;
  }

  // Check if user is client
  Future<bool> isClient() async {
    final user = await getCurrentUser();
    return user?.role == UserRole.client;
  }

  // Check if user is freelancer
  Future<bool> isFreelancer() async {
    final user = await getCurrentUser();
    return user?.role == UserRole.freelancer;
  }

  // Load user from Firestore
  Future<void> _loadUserFromFirestore(String userId) async {
    try {
      final userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final userModel = UserModel.fromFirestore(userDoc);
        await _saveUserToLocal(userModel);
      }
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Save user to local storage
  Future<void> _saveUserToLocal(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', user.toFirestore().toString());
    } catch (e) {
      // Handle local storage error
    }
  }

  // Clear user from local storage
  Future<void> _clearUserFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user');
    } catch (e) {
      // Handle local storage error
    }
  }

  // Handle authentication errors
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'email-already-in-use':
          return 'An account already exists with this email address.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'invalid-email':
          return 'Invalid email address.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later.';
        default:
          return 'Authentication failed. Please try again.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
