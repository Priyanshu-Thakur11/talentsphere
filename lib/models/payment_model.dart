import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentStatus { pending, processing, completed, failed, refunded, disputed }
enum PaymentMethod { stripe, paypal, bank_transfer, crypto }

class PaymentModel {
  final String id;
  final String projectId;
  final String fromUserId;
  final String toUserId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final PaymentMethod method;
  final String? transactionId;
  final String? stripePaymentIntentId;
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? description;
  final Map<String, dynamic> metadata;
  final String? failureReason;
  final double? platformFee;
  final double? freelancerAmount;

  PaymentModel({
    required this.id,
    required this.projectId,
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
    this.currency = 'USD',
    this.status = PaymentStatus.pending,
    required this.method,
    this.transactionId,
    this.stripePaymentIntentId,
    required this.createdAt,
    this.processedAt,
    this.description,
    this.metadata = const {},
    this.failureReason,
    this.platformFee,
    this.freelancerAmount,
  });

  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PaymentModel(
      id: doc.id,
      projectId: data['projectId'] ?? '',
      fromUserId: data['fromUserId'] ?? '',
      toUserId: data['toUserId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'USD',
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${data['status']}',
        orElse: () => PaymentStatus.pending,
      ),
      method: PaymentMethod.values.firstWhere(
        (e) => e.toString() == 'PaymentMethod.${data['method']}',
        orElse: () => PaymentMethod.stripe,
      ),
      transactionId: data['transactionId'],
      stripePaymentIntentId: data['stripePaymentIntentId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      processedAt: data['processedAt'] != null 
          ? (data['processedAt'] as Timestamp).toDate() 
          : null,
      description: data['description'],
      metadata: Map<String, dynamic>.from(data['metadata'] ?? {}),
      failureReason: data['failureReason'],
      platformFee: data['platformFee']?.toDouble(),
      freelancerAmount: data['freelancerAmount']?.toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'projectId': projectId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'amount': amount,
      'currency': currency,
      'status': status.toString().split('.').last,
      'method': method.toString().split('.').last,
      'transactionId': transactionId,
      'stripePaymentIntentId': stripePaymentIntentId,
      'createdAt': Timestamp.fromDate(createdAt),
      'processedAt': processedAt != null ? Timestamp.fromDate(processedAt!) : null,
      'description': description,
      'metadata': metadata,
      'failureReason': failureReason,
      'platformFee': platformFee,
      'freelancerAmount': freelancerAmount,
    };
  }
}

class MilestonePaymentModel {
  final String id;
  final String projectId;
  final String milestoneId;
  final String freelancerId;
  final String clientId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final DateTime dueDate;
  final DateTime? paidAt;
  final String? paymentId;
  final String? description;
  final List<String> deliverables;

  MilestonePaymentModel({
    required this.id,
    required this.projectId,
    required this.milestoneId,
    required this.freelancerId,
    required this.clientId,
    required this.amount,
    this.currency = 'USD',
    this.status = PaymentStatus.pending,
    required this.dueDate,
    this.paidAt,
    this.paymentId,
    this.description,
    this.deliverables = const [],
  });

  factory MilestonePaymentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MilestonePaymentModel(
      id: doc.id,
      projectId: data['projectId'] ?? '',
      milestoneId: data['milestoneId'] ?? '',
      freelancerId: data['freelancerId'] ?? '',
      clientId: data['clientId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'USD',
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${data['status']}',
        orElse: () => PaymentStatus.pending,
      ),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      paidAt: data['paidAt'] != null 
          ? (data['paidAt'] as Timestamp).toDate() 
          : null,
      paymentId: data['paymentId'],
      description: data['description'],
      deliverables: List<String>.from(data['deliverables'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'projectId': projectId,
      'milestoneId': milestoneId,
      'freelancerId': freelancerId,
      'clientId': clientId,
      'amount': amount,
      'currency': currency,
      'status': status.toString().split('.').last,
      'dueDate': Timestamp.fromDate(dueDate),
      'paidAt': paidAt != null ? Timestamp.fromDate(paidAt!) : null,
      'paymentId': paymentId,
      'description': description,
      'deliverables': deliverables,
    };
  }
}
