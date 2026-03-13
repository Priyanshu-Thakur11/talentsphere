import 'package:cloud_firestore/cloud_firestore.dart';

enum TeamRole { leader, member, admin }
enum TeamStatus { active, inactive, pending, disbanded }

class TeamModel {
  final String id;
  final String name;
  final String description;
  final String leaderId;
  final List<TeamMember> members;
  final TeamStatus status;
  final String? logoUrl;
  final List<String> skills;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> settings;
  final int completedProjects;
  final double totalEarnings;
  final double rating;
  final int totalReviews;

  TeamModel({
    required this.id,
    required this.name,
    required this.description,
    required this.leaderId,
    this.members = const [],
    this.status = TeamStatus.active,
    this.logoUrl,
    this.skills = const [],
    this.location,
    required this.createdAt,
    required this.updatedAt,
    this.settings = const {},
    this.completedProjects = 0,
    this.totalEarnings = 0.0,
    this.rating = 0.0,
    this.totalReviews = 0,
  });

  factory TeamModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TeamModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      leaderId: data['leaderId'] ?? '',
      members: (data['members'] as List<dynamic>?)
          ?.map((m) => TeamMember.fromMap(m))
          .toList() ?? [],
      status: TeamStatus.values.firstWhere(
        (e) => e.toString() == 'TeamStatus.${data['status']}',
        orElse: () => TeamStatus.active,
      ),
      logoUrl: data['logoUrl'],
      skills: List<String>.from(data['skills'] ?? []),
      location: data['location'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      settings: Map<String, dynamic>.from(data['settings'] ?? {}),
      completedProjects: data['completedProjects'] ?? 0,
      totalEarnings: (data['totalEarnings'] ?? 0.0).toDouble(),
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'leaderId': leaderId,
      'members': members.map((m) => m.toMap()).toList(),
      'status': status.toString().split('.').last,
      'logoUrl': logoUrl,
      'skills': skills,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'settings': settings,
      'completedProjects': completedProjects,
      'totalEarnings': totalEarnings,
      'rating': rating,
      'totalReviews': totalReviews,
    };
  }
}

class TeamMember {
  final String userId;
  final String name;
  final String? profileImageUrl;
  final TeamRole role;
  final DateTime joinedAt;
  final List<String> skills;
  final double? hourlyRate;
  final bool isActive;

  TeamMember({
    required this.userId,
    required this.name,
    this.profileImageUrl,
    required this.role,
    required this.joinedAt,
    this.skills = const [],
    this.hourlyRate,
    this.isActive = true,
  });

  factory TeamMember.fromMap(Map<String, dynamic> data) {
    return TeamMember(
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      role: TeamRole.values.firstWhere(
        (e) => e.toString() == 'TeamRole.${data['role']}',
        orElse: () => TeamRole.member,
      ),
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
      skills: List<String>.from(data['skills'] ?? []),
      hourlyRate: data['hourlyRate']?.toDouble(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'role': role.toString().split('.').last,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'skills': skills,
      'hourlyRate': hourlyRate,
      'isActive': isActive,
    };
  }
}
