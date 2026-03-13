import 'package:cloud_firestore/cloud_firestore.dart';

enum ProjectStatus { draft, published, inProgress, completed, cancelled, disputed }
enum ProjectType { fixed, hourly, milestone }

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String clientId;
  final String? freelancerId;
  final ProjectType type;
  final ProjectStatus status;
  final double budget;
  final String currency;
  final int duration; // in days
  final List<String> requiredSkills;
  final List<String> tags;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deadline;
  final List<MilestoneModel> milestones;
  final List<String> attachments;
  final Map<String, dynamic> requirements;
  final bool isUrgent;
  final String? location;
  final String? timezone;
  final int proposalsCount;
  final double? clientRating;
  final String? clientReview;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.clientId,
    this.freelancerId,
    required this.type,
    this.status = ProjectStatus.draft,
    required this.budget,
    this.currency = 'USD',
    required this.duration,
    this.requiredSkills = const [],
    this.tags = const [],
    this.category,
    required this.createdAt,
    required this.updatedAt,
    this.deadline,
    this.milestones = const [],
    this.attachments = const [],
    this.requirements = const {},
    this.isUrgent = false,
    this.location,
    this.timezone,
    this.proposalsCount = 0,
    this.clientRating,
    this.clientReview,
  });

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProjectModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      clientId: data['clientId'] ?? '',
      freelancerId: data['freelancerId'],
      type: ProjectType.values.firstWhere(
        (e) => e.toString() == 'ProjectType.${data['type']}',
        orElse: () => ProjectType.fixed,
      ),
      status: ProjectStatus.values.firstWhere(
        (e) => e.toString() == 'ProjectStatus.${data['status']}',
        orElse: () => ProjectStatus.draft,
      ),
      budget: (data['budget'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'USD',
      duration: data['duration'] ?? 0,
      requiredSkills: List<String>.from(data['requiredSkills'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      category: data['category'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      deadline: data['deadline'] != null 
          ? (data['deadline'] as Timestamp).toDate() 
          : null,
      milestones: (data['milestones'] as List<dynamic>?)
          ?.map((m) => MilestoneModel.fromMap(m))
          .toList() ?? [],
      attachments: List<String>.from(data['attachments'] ?? []),
      requirements: Map<String, dynamic>.from(data['requirements'] ?? {}),
      isUrgent: data['isUrgent'] ?? false,
      location: data['location'],
      timezone: data['timezone'],
      proposalsCount: data['proposalsCount'] ?? 0,
      clientRating: data['clientRating']?.toDouble(),
      clientReview: data['clientReview'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'clientId': clientId,
      'freelancerId': freelancerId,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'budget': budget,
      'currency': currency,
      'duration': duration,
      'requiredSkills': requiredSkills,
      'tags': tags,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'milestones': milestones.map((m) => m.toMap()).toList(),
      'attachments': attachments,
      'requirements': requirements,
      'isUrgent': isUrgent,
      'location': location,
      'timezone': timezone,
      'proposalsCount': proposalsCount,
      'clientRating': clientRating,
      'clientReview': clientReview,
    };
  }

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    String? clientId,
    String? freelancerId,
    ProjectType? type,
    ProjectStatus? status,
    double? budget,
    String? currency,
    int? duration,
    List<String>? requiredSkills,
    List<String>? tags,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deadline,
    List<MilestoneModel>? milestones,
    List<String>? attachments,
    Map<String, dynamic>? requirements,
    bool? isUrgent,
    String? location,
    String? timezone,
    int? proposalsCount,
    double? clientRating,
    String? clientReview,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      clientId: clientId ?? this.clientId,
      freelancerId: freelancerId ?? this.freelancerId,
      type: type ?? this.type,
      status: status ?? this.status,
      budget: budget ?? this.budget,
      currency: currency ?? this.currency,
      duration: duration ?? this.duration,
      requiredSkills: requiredSkills ?? this.requiredSkills,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deadline: deadline ?? this.deadline,
      milestones: milestones ?? this.milestones,
      attachments: attachments ?? this.attachments,
      requirements: requirements ?? this.requirements,
      isUrgent: isUrgent ?? this.isUrgent,
      location: location ?? this.location,
      timezone: timezone ?? this.timezone,
      proposalsCount: proposalsCount ?? this.proposalsCount,
      clientRating: clientRating ?? this.clientRating,
      clientReview: clientReview ?? this.clientReview,
    );
  }
}

class MilestoneModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime dueDate;
  final bool isCompleted;
  final DateTime? completedAt;
  final String? notes;
  final List<String> deliverables;

  MilestoneModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.dueDate,
    this.isCompleted = false,
    this.completedAt,
    this.notes,
    this.deliverables = const [],
  });

  factory MilestoneModel.fromMap(Map<String, dynamic> data) {
    return MilestoneModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
      completedAt: data['completedAt'] != null 
          ? (data['completedAt'] as Timestamp).toDate() 
          : null,
      notes: data['notes'],
      deliverables: List<String>.from(data['deliverables'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'dueDate': Timestamp.fromDate(dueDate),
      'isCompleted': isCompleted,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
      'notes': notes,
      'deliverables': deliverables,
    };
  }
}

class ProposalModel {
  final String id;
  final String projectId;
  final String freelancerId;
  final double bidAmount;
  final int timeEstimateDays;
  final String coverLetter;
  final ProposalStatus status;
  final DateTime createdAt;

  ProposalModel({
    required this.id,
    required this.projectId,
    required this.freelancerId,
    required this.bidAmount,
    required this.timeEstimateDays,
    required this.coverLetter,
    this.status = ProposalStatus.pending,
    required this.createdAt,
  });

  factory ProposalModel.fromMap(Map<String, dynamic> data) {
    return ProposalModel(
      id: data['id'] ?? '',
      projectId: data['projectId'] ?? '',
      freelancerId: data['freelancerId'] ?? '',
      bidAmount: (data['bidAmount'] ?? 0.0).toDouble(),
      timeEstimateDays: data['timeEstimateDays'] ?? 0,
      coverLetter: data['coverLetter'] ?? '',
      status: ProposalStatus.values.firstWhere(
        (e) => e.toString() == 'ProposalStatus.${data['status']}',
        orElse: () => ProposalStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectId': projectId,
      'freelancerId': freelancerId,
      'bidAmount': bidAmount,
      'timeEstimateDays': timeEstimateDays,
      'coverLetter': coverLetter,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

enum ProposalStatus { pending, accepted, rejected, withdrawn }

enum ReviewTarget { freelancer, client }

class ReviewModel {
  final String id;
  final String projectId;
  final String giverId; // ID of the user who gave the review (Client or Freelancer)
  final String receiverId; // ID of the user who received the review (Freelancer or Client)
  final ReviewTarget receiverRole;
  final double rating;
  final String reviewText;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.projectId,
    required this.giverId,
    required this.receiverId,
    required this.receiverRole,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ReviewModel(
      id: doc.id,
      projectId: data['projectId'] ?? '',
      giverId: data['giverId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      receiverRole: ReviewTarget.values.firstWhere(
        (e) => e.toString() == 'ReviewTarget.${data['receiverRole']}',
        orElse: () => ReviewTarget.freelancer,
      ),
      rating: (data['rating'] ?? 0.0).toDouble(),
      reviewText: data['reviewText'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'projectId': projectId,
      'giverId': giverId,
      'receiverId': receiverId,
      'receiverRole': receiverRole.toString().split('.').last,
      'rating': rating,
      'reviewText': reviewText,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
