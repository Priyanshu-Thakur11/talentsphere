// lib/Projects/review_submission_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Placeholder for rating bar
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:nileshapp/models/project_model.dart';
import 'package:nileshapp/models/user_model.dart';
import 'package:nileshapp/providers/auth_provider.dart';
import 'package:nileshapp/services/firestore_service.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;

class ReviewSubmissionScreen extends StatefulWidget {
  final ProjectModel project;
  final String receiverId; // The ID of the person receiving the review
  final ReviewTarget receiverRole;

  const ReviewSubmissionScreen({
    super.key,
    required this.project,
    required this.receiverId,
    required this.receiverRole,
  });

  @override
  State<ReviewSubmissionScreen> createState() => _ReviewSubmissionScreenState();
}

class _ReviewSubmissionScreenState extends State<ReviewSubmissionScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0.0;
  bool _isLoading = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (_rating == 0.0) {
      _showErrorSnackBar('Please provide a rating.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final giverId = authProvider.userModel?.id;

    if (giverId == null) {
      _showErrorSnackBar('Authentication error.');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final review = ReviewModel(
        id: const Uuid().v4(),
        projectId: widget.project.id,
        giverId: giverId,
        receiverId: widget.receiverId,
        receiverRole: widget.receiverRole,
        rating: _rating,
        reviewText: _reviewController.text.trim(),
        createdAt: DateTime.now(),
      );

      // Save the review to Firestore
      await FirestoreService.instance.createReview(review);

      // TODO: Implement logic to update the average rating on the receiver's UserModel (This is complex and left as a future step for the user)
      // For now, we only save the review object.

      _showSuccessSnackBar('Review submitted successfully!');
      Navigator.pop(context);

    } catch (e) {
      _showErrorSnackBar('Failed to submit review: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final receiverName = widget.receiverRole == ReviewTarget.freelancer 
        ? 'Freelancer' // Replace with actual freelancer name lookup
        : 'Client'; // Replace with actual client name lookup

    return Scaffold(
      backgroundColor: kDarkBackground,
      appBar: AppBar(
        title: Text('Review $receiverName', style: const TextStyle(color: Colors.white)),
        backgroundColor: kDarkBackground,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.6),
                radius: 1.5,
                colors: [Color(0xFF1E1436), kDarkBackground],
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How was your experience on "${widget.project.title}"?',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 24),
                
                // Rating Bar
                Center(
                  child: RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: kAccentTeal,
                    ),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Rating: $_rating / 5.0',
                    style: const TextStyle(color: kTextSecondary, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 40),

                // Review Text Field
                Text(
                  'Write a Review',
                  style: TextStyle(color: kTextSecondary, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: kCardColor,
                    borderRadius: BorderRadius.circular(kCardRadius),
                    border: Border.all(color: kPrimaryPurple.withOpacity(0.3)),
                  ),
                  child: TextField(
                    controller: _reviewController,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Share your honest feedback...',
                      hintStyle: TextStyle(color: kTextSecondary),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Submit Button
                Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [kAccentTeal, kPrimaryPurple],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(kCardRadius),
                  ),
                  child: TextButton(
                    onPressed: _isLoading ? null : _submitReview,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator(color: Colors.white))
                        : const Text(
                            'Submit Review',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}