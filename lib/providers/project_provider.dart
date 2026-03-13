import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../services/firestore_service.dart';
import '../services/notification_service.dart';
import '../models/user_model.dart';

class ProjectProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService.instance;
  
  List<ProjectModel> _projects = [];
  List<ProjectModel> _myProjects = [];
  List<ProjectModel> _availableProjects = [];
  bool _isLoading = false;
  String? _error;

  List<ProjectModel> get projects => _projects;
  List<ProjectModel> get myProjects => _myProjects;
  List<ProjectModel> get availableProjects => _availableProjects;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProjects({
    String? clientId,
    String? freelancerId,
    ProjectStatus? status,
    int limit = 20,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _projects = await _firestoreService.getProjects(
        clientId: clientId,
        freelancerId: freelancerId,
        status: status,
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

  Future<void> loadMyProjects(String userId, {int limit = 20}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _myProjects = await _firestoreService.getProjects(
        clientId: userId,
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

  Future<void> loadAvailableProjects({int limit = 20}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _availableProjects = await _firestoreService.getProjects(
        status: ProjectStatus.published,
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

  Future<void> loadAllProjects({int limit = 50}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Load all projects regardless of status - visible to all users
      _projects = await _firestoreService.getProjects(
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

  Future<String> createProject(ProjectModel project, UserModel client) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final projectId = await _firestoreService.createProject(project);
      
      // Send notifications to all freelancers about the new project
      await _notifyFreelancersAboutNewProject(project, client);

      _isLoading = false;
      notifyListeners();
      return projectId;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _notifyFreelancersAboutNewProject(ProjectModel project, UserModel client) async {
    try {
      // Get all freelancers
      final freelancers = await _firestoreService.getUsers(
        role: UserRole.freelancer,
        limit: 100,
      );

      // Send notification to each freelancer
      for (final freelancer in freelancers) {
        await NotificationService.instance.sendProjectPostedNotification(
          userId: freelancer.id,
          projectTitle: project.title,
          clientName: client.name,
          projectId: project.id,
        );
      }
    } catch (e) {
      // Log error but don't fail the project creation
      print('Failed to send project notifications: $e');
    }
  }

  Future<ProjectModel?> getProject(String projectId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final project = await _firestoreService.getProject(projectId);

      _isLoading = false;
      notifyListeners();
      return project;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> updateProject(ProjectModel project) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _firestoreService.updateProject(project);

      // Update local lists
      final projectIndex = _projects.indexWhere((p) => p.id == project.id);
      if (projectIndex != -1) {
        _projects[projectIndex] = project;
      }

      final myProjectIndex = _myProjects.indexWhere((p) => p.id == project.id);
      if (myProjectIndex != -1) {
        _myProjects[myProjectIndex] = project;
      }

      final availableProjectIndex = _availableProjects.indexWhere((p) => p.id == project.id);
      if (availableProjectIndex != -1) {
        _availableProjects[availableProjectIndex] = project;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<ProjectModel>> searchProjects({
    String? query,
    List<String>? skills,
    double? minBudget,
    double? maxBudget,
    int limit = 20,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final results = await _firestoreService.searchProjects(
        query: query,
        skills: skills,
        minBudget: minBudget,
        maxBudget: maxBudget,
        limit: limit,
      );

      _isLoading = false;
      notifyListeners();
      return results;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return [];
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
