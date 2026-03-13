import 'package:flutter/material.dart';
import 'package:nileshapp/AI_TOOL/aitool_card.dart';
import 'package:nileshapp/Theme/estimatorsubpill.dart';
import 'package:nileshapp/Theme/linearchart_placeholder.dart';
import 'package:nileshapp/Theme/percentagepill.dart';
import 'package:nileshapp/Theme/radialchart_placeholder.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB); 
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;
class AIToolsScreen extends StatelessWidget {
  const AIToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Custom Background (simulating the depth and glow)
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.6),
                radius: 1.5,
                colors: [
                  Color(0xFF1E1436), // Dark center glow
                  kDarkBackground,
                ],
              ),
            ),
          ),

          // Main Scrollable Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildResumeAnalyzer(),
                  _buildAIMatchmaking(),
                  _buildAIProjectEstimator(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'AI Tools',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(
          Icons.search_rounded,
          color: Colors.white,
          size: 30,
        ),
      ],
    );
  }

  Widget _buildResumeAnalyzer() {
    return AIToolCard(
      title: 'AI Resume Analyzer',
      icon: Icons.search_rounded,
      iconColor: kPrimaryPurple,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                // Upload buttons
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: kCardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kTextSecondary.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.upload_file_rounded, color: kTextSecondary),
                      const SizedBox(width: 10),
                      Text('Upload Resume', style: TextStyle(color: kTextSecondary)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [kAccentPink.withOpacity(0.8), kPrimaryPurple],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: kAccentPink.withOpacity(0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.upload_file_rounded, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Upload Resume', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Radial Chart
          const RadialChartPlaceholder(),
        ],
      ),
    );
  }

  Widget _buildAIMatchmaking() {
    return AIToolCard(
      title: 'AI Matchmaking',
      icon: Icons.psychology_rounded,
      iconColor: kAccentPink,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          PercentagePill(
            label: 'Book Interviews',
            percentage: '16%',
            color: kAccentTeal,
          ),
          PercentagePill(
            label: 'Recommended Projects',
            percentage: '28%',
            color: kPrimaryPurple,
          ),
          PercentagePill(
            label: 'Project',
            percentage: '43%',
            color: kAccentPink,
          ),
        ],
      ),
    );
  }

  Widget _buildAIProjectEstimator() {
    return AIToolCard(
      title: 'AI Project Estimator',
      icon: Icons.bar_chart_rounded,
      iconColor: kAccentTeal,
      content: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              EstimatorSubPill(
                icon: Icons.check_circle_rounded,
                title: 'Success',
                subtext: 'Fee release (if applicable)',
                percentage: '28%',
                color: kPrimaryPurple,
              ),
              EstimatorSubPill(
                icon: Icons.star_rounded,
                title: 'Deliverables',
                subtext: 'Teamwork (Shared purse)',
                percentage: '38%',
                color: kAccentPink,
              ),
              EstimatorSubPill(
                icon: Icons.gpp_good_rounded,
                title: 'Success',
                subtext: 'Fee release (if applicable)',
                percentage: '43%',
                color: kAccentTeal,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Estimator Input Fields (simplified rows)
          _buildEstimatorRow('Scope', 'Rate'),
          _buildEstimatorRow('Hours', 'Timeline'),
          _buildEstimatorRow('Estimated Cost', null, isChart: true),
        ],
      ),
    );
  }

  Widget _buildEstimatorRow(String label1, String? label2, {bool isChart = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Input 1
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label1, style: TextStyle(color: kTextSecondary, fontSize: 13)),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: kTextSecondary.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
          // Input 2 or Chart
          Expanded(
            child: label2 != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label2, style: TextStyle(color: kTextSecondary, fontSize: 13)),
                      Container(
                        height: 40,
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: kTextSecondary.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  )
                : const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: LineChartPlaceholder(),
                  ),
          ),
        ],
      ),
    );
  }
}



