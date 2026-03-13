// lib/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { freelancer, client, admin }
enum UserStatus { active, inactive, pending, suspended }

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? profileImageUrl;
  final UserRole role;
  final UserStatus status;
  final String? phoneNumber;
  final String? bio;
  final List<String> skills;
  final double? hourlyRate;
  final String? location;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> preferences;
  final List<String> certifications;
  final int totalEarnings;
  final int completedProjects;
  final double rating;
  final int totalReviews;
  final String? resumeUrl; // 👈 ADDED FIELD

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profileImageUrl,
    required this.role,
    this.status = UserStatus.active,
    this.phoneNumber,
    this.bio,
    this.skills = const [],
    this.hourlyRate,
    this.location,
    required this.createdAt,
    required this.updatedAt,
    this.preferences = const {},
    this.certifications = const [],
    this.totalEarnings = 0,
    this.completedProjects = 0,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.resumeUrl, // 👈 ADDED FIELD
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${data['role']}',
        orElse: () => UserRole.freelancer,
      ),
      status: UserStatus.values.firstWhere(
        (e) => e.toString() == 'UserStatus.${data['status']}',
        orElse: () => UserStatus.active,
      ),
      phoneNumber: data['phoneNumber'],
      bio: data['bio'],
      skills: List<String>.from(data['skills'] ?? []),
      hourlyRate: data['hourlyRate']?.toDouble(),
      location: data['location'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      preferences: Map<String, dynamic>.from(data['preferences'] ?? {}),
      certifications: List<String>.from(data['certifications'] ?? []),
      totalEarnings: data['totalEarnings'] ?? 0,
      completedProjects: data['completedProjects'] ?? 0,
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalReviews: data['totalReviews'] ?? 0,
      resumeUrl: data['resumeUrl'], // 👈 ADDED FIELD
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'role': role.toString().split('.').last,
      'status': status.toString().split('.').last,
      'phoneNumber': phoneNumber,
      'bio': bio,
      'skills': skills,
      'hourlyRate': hourlyRate,
      'location': location,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'preferences': preferences,
      'certifications': certifications,
      'totalEarnings': totalEarnings,
      'completedProjects': completedProjects,
      'rating': rating,
      'totalReviews': totalReviews,
      'resumeUrl': resumeUrl, // 👈 ADDED FIELD
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImageUrl,
    UserRole? role,
    UserStatus? status,
    String? phoneNumber,
    String? bio,
    List<String>? skills,
    double? hourlyRate,
    String? location,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? preferences,
    List<String>? certifications,
    int? totalEarnings,
    int? completedProjects,
    double? rating,
    int? totalReviews,
    String? resumeUrl, // 👈 ADDED FIELD
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      skills: skills ?? this.skills,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
      certifications: certifications ?? this.certifications,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      completedProjects: completedProjects ?? this.completedProjects,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      resumeUrl: resumeUrl ?? this.resumeUrl, // 👈 ADDED FIELD
    );
  }
}