import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class UserProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService.instance;
  
  List<UserModel> _users = [];
  List<UserModel> _freelancers = [];
  List<UserModel> _clients = [];
  bool _isLoading = false;
  String? _error;

  List<UserModel> get users => _users;
  List<UserModel> get freelancers => _freelancers;
  List<UserModel> get clients => _clients;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadUsers({UserRole? role, int limit = 20}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _users = await _firestoreService.getUsers(
        role: role,
        limit: limit,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFreelancers({int limit = 20}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _freelancers = await _firestoreService.getUsers(
        role: UserRole.freelancer,
        limit: limit,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadClients({int limit = 20}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _clients = await _firestoreService.getUsers(
        role: UserRole.client,
        limit: limit,
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final user = await _firestoreService.getUser(userId);

      _isLoading = false;
      notifyListeners();
      return user;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestoreService.updateUser(user);

      // Update local lists
      final userIndex = _users.indexWhere((u) => u.id == user.id);
      if (userIndex != -1) {
        _users[userIndex] = user;
      }

      final freelancerIndex = _freelancers.indexWhere((u) => u.id == user.id);
      if (freelancerIndex != -1) {
        _freelancers[freelancerIndex] = user;
      }

      final clientIndex = _clients.indexWhere((u) => u.id == user.id);
      if (clientIndex != -1) {
        _clients[clientIndex] = user;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
