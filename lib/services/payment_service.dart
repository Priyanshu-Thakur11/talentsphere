import '../models/payment_model.dart';
import 'firestore_service.dart';

//enum PaymentStatus { pending, processing, completed, failed, refunded, disputed, heldInEscrow }


class PaymentService {
  static PaymentService? _instance;
  static PaymentService get instance {
    _instance ??= PaymentService._();
    return _instance!;
  }

  PaymentService._();

  final FirestoreService _firestoreService = FirestoreService.instance;

  // Initialize Stripe (simplified)
  Future<void> initializeStripe({
    required String publishableKey,
  }) async {
    try {
      // Simplified Stripe initialization
      // In a real app, you'd configure Stripe here
      print('Stripe initialized with key: $publishableKey');
    } catch (e) {
      throw Exception('Failed to initialize Stripe: $e');
    }
  }

  // Create payment intent (simplified)
  Future<Map<String, dynamic>> createPaymentIntent({
    required double amount,
    required String currency,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Simplified payment intent creation
      // In a real app, you'd integrate with Stripe API
      return {
        'id': 'pi_${DateTime.now().millisecondsSinceEpoch}',
        'amount': amount,
        'currency': currency,
        'status': 'requires_payment_method',
      };
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  // Process payment (simplified)
  Future<PaymentResult> processPayment({
    required String paymentMethodId,
    required double amount,
    required String currency,
    required String projectId,
    required String fromUserId,
    required String toUserId,
    String? description,
  }) async {
    try {
      // Simplified payment processing
      // In a real app, you'd integrate with Stripe API
      final transactionId = 'txn_${DateTime.now().millisecondsSinceEpoch}';
      
      // Create payment record in Firestore
      final payment = PaymentModel(
        id: '', // Will be set by Firestore
        projectId: projectId,
        fromUserId: fromUserId,
        toUserId: toUserId,
        amount: amount,
        currency: currency,
        status: PaymentStatus.completed,
        method: PaymentMethod.stripe,
        transactionId: transactionId,
        stripePaymentIntentId: paymentMethodId,
        createdAt: DateTime.now(),
        processedAt: DateTime.now(),
        description: description,
        platformFee: _calculatePlatformFee(amount),
        freelancerAmount: _calculateFreelancerAmount(amount),
      );

      final paymentId = await _firestoreService.createPayment(payment);
      
      // Update project status if needed
      await _updateProjectPaymentStatus(projectId, paymentId);

      return PaymentResult(
        success: true,
        paymentId: paymentId,
        transactionId: transactionId,
      );
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }

  // Process milestone payment
  Future<PaymentResult> processMilestonePayment({
    required String projectId,
    required String milestoneId,
    required double amount,
    required String freelancerId,
    required String clientId,
    String? description,
  }) async {
    try {
      // Create milestone payment record
      final milestonePayment = MilestonePaymentModel(
        id: '',
        projectId: projectId,
        milestoneId: milestoneId,
        freelancerId: freelancerId,
        clientId: clientId,
        amount: amount,
        status: PaymentStatus.pending,
        dueDate: DateTime.now().add(const Duration(days: 7)),
        description: description,
      );

      // Create payment intent for milestone
      final paymentIntent = await createPaymentIntent(
        amount: amount,
        currency: 'USD',
        description: description ?? 'Milestone payment',
        metadata: {
          'projectId': projectId,
          'milestoneId': milestoneId,
          'type': 'milestone',
        },
      );

      return PaymentResult(
        success: true,
        paymentId: milestonePayment.id,
        transactionId: paymentIntent['id'] ?? '',
      );
    } catch (e) {
      throw Exception('Failed to process milestone payment: $e');
    }
  }

  // Get payment history
  Future<List<PaymentModel>> getPaymentHistory({
    required String userId,
    PaymentStatus? status,
    int limit = 20,
  }) async {
    try {
      return await _firestoreService.getPayments(
        userId: userId,
        status: status,
        limit: limit,
      );
    } catch (e) {
      throw Exception('Failed to get payment history: $e');
    }
  }

  // Get payment by ID
  Future<PaymentModel?> getPayment(String paymentId) async {
    try {
      return await _firestoreService.getPayment(paymentId);
    } catch (e) {
      throw Exception('Failed to get payment: $e');
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus({
    required String paymentId,
    required PaymentStatus status,
    String? failureReason,
  }) async {
    try {
      final payment = await getPayment(paymentId);
      if (payment != null) {
        final updatedPayment = PaymentModel(
          id: payment.id,
          projectId: payment.projectId,
          fromUserId: payment.fromUserId,
          toUserId: payment.toUserId,
          amount: payment.amount,
          currency: payment.currency,
          status: status,
          method: payment.method,
          transactionId: payment.transactionId,
          stripePaymentIntentId: payment.stripePaymentIntentId,
          createdAt: payment.createdAt,
          processedAt: status == PaymentStatus.completed ? DateTime.now() : payment.processedAt,
          description: payment.description,
          metadata: payment.metadata,
          failureReason: failureReason,
          platformFee: payment.platformFee,
          freelancerAmount: payment.freelancerAmount,
        );

        await _firestoreService.updatePayment(updatedPayment);
      }
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  // Refund payment
  Future<PaymentResult> refundPayment({
    required String paymentId,
    double? amount,
    String? reason,
  }) async {
    try {
      final payment = await getPayment(paymentId);
      if (payment == null) {
        throw Exception('Payment not found');
      }

      if (payment.status != PaymentStatus.completed) {
        throw Exception('Cannot refund non-completed payment');
      }

      // Here you would integrate with Stripe's refund API
      // For now, we'll just update the status
      await updatePaymentStatus(
        paymentId: paymentId,
        status: PaymentStatus.refunded,
        failureReason: reason,
      );

      return PaymentResult(
        success: true,
        paymentId: paymentId,
        transactionId: payment.transactionId ?? '',
      );
    } catch (e) {
      throw Exception('Failed to refund payment: $e');
    }
  }

  // Calculate platform fee (5% of total amount)
  double _calculatePlatformFee(double amount) {
    return amount * 0.05;
  }

  // Calculate freelancer amount (95% of total amount)
  double _calculateFreelancerAmount(double amount) {
    return amount * 0.95;
  }

  // Update project payment status
  Future<void> _updateProjectPaymentStatus(String projectId, String paymentId) async {
    try {
      final project = await _firestoreService.getProject(projectId);
      if (project != null) {
        // Update project with payment information
        // This would depend on your project model structure
        await _firestoreService.updateProject(project);
      }
    } catch (e) {
      throw Exception('Failed to update project payment status: $e');
    }
  }

  // Get payment statistics
  Future<PaymentStatistics> getPaymentStatistics(String userId) async {
    try {
      final payments = await getPaymentHistory(userId: userId);
      
      double totalEarnings = 0;
      double totalSpent = 0;
      int completedPayments = 0;
      int pendingPayments = 0;
      int failedPayments = 0;

      for (final payment in payments) {
        if (payment.toUserId == userId) {
          totalEarnings += payment.amount;
        } else {
          totalSpent += payment.amount;
        }

        switch (payment.status) {
          case PaymentStatus.completed:
            completedPayments++;
            break;
          case PaymentStatus.pending:
            pendingPayments++;
            break;
          case PaymentStatus.failed:
            failedPayments++;
            break;
          default:
            break;
        }
      }

      return PaymentStatistics(
        totalEarnings: totalEarnings,
        totalSpent: totalSpent,
        completedPayments: completedPayments,
        pendingPayments: pendingPayments,
        failedPayments: failedPayments,
      );
    } catch (e) {
      throw Exception('Failed to get payment statistics: $e');
    }
  }
}

// Payment result class
class PaymentResult {
  final bool success;
  final String? paymentId;
  final String? transactionId;
  final String? error;

  PaymentResult({
    required this.success,
    this.paymentId,
    this.transactionId,
    this.error,
  });
}

// Payment statistics class
class PaymentStatistics {
  final double totalEarnings;
  final double totalSpent;
  final int completedPayments;
  final int pendingPayments;
  final int failedPayments;

  PaymentStatistics({
    required this.totalEarnings,
    required this.totalSpent,
    required this.completedPayments,
    required this.pendingPayments,
    required this.failedPayments,
  });
}
