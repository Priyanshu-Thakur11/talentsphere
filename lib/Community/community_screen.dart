import 'dart:ui'; // 👈 Needed for glass blur effect

import 'package:flutter/material.dart';
import 'package:nileshapp/Community/blogarticle_card.dart';
import 'package:nileshapp/Community/categorypill.dart';
import 'package:nileshapp/Community/floatinadd_button.dart';
import 'package:nileshapp/Community/hackaton_card.dart';
import 'package:nileshapp/Community/learinghub_card.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB);
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- Background ---
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.6),
                radius: 1.5,
                colors: [
                  Color(0xFF1E1436),
                  kDarkBackground,
                ],
              ),
            ),
          ),

          // --- Main Scrollable Content ---
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),

                  // Discussion Categories
                  _buildSectionTitle('Discussion Forum'),
                  const SizedBox(height: 12),
                  _buildDiscussionCategories(),
                  const SizedBox(height: 30),

                  // Hackathons
                  _buildSectionTitle('Hackathons & Challenges'),
                  const SizedBox(height: 12),
                  const HackathonCard(
                    title: 'Future Founders',
                    time: '08:21:45',
                    participants: '11:37:96',
                    color: kPrimaryPurple,
                  ),
                  const SizedBox(height: 30),

                  // Learning Hub
                  _buildSectionTitle('Learning Hub'),
                  const SizedBox(height: 12),
                  _buildLearningHub(),
                  const SizedBox(height: 30),

                  // Blogs
                  _buildSectionTitle('Blogs & Articles'),
                  const SizedBox(height: 12),
                  _buildBlogsAndArticles(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Floating Add Button
          const Positioned(
            bottom: 30,
            right: 30,
            child: FloatingAddButton(),
          ),
        ],
      ),
    );
  }

  // --- HEADER WITH MENU BUTTON ---
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Community',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // --- SECTION TITLE ---
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: kTextSecondary.withOpacity(0.9),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // --- DISCUSSION CATEGORIES ---
  Widget _buildDiscussionCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          CategoryPill(
            title: 'Flutter Q&A',
            subText: '+150 likes',
            icon: Icons.chat_bubble,
            color: kAccentTeal,
          ),
          CategoryPill(
            title: 'AI/ML Trends',
            subText: '+161 likes',
            icon: Icons.local_fire_department,
            color: kAccentPink,
          ),
          CategoryPill(
            title: 'UI/UX Tips',
            subText: '+188 likes',
            icon: Icons.palette,
            color: kPrimaryPurple,
          ),
        ],
      ),
    );
  }

  // --- LEARNING HUB ---
  Widget _buildLearningHub() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          LearningHubCard(
            title: 'Mastering Prompt Engineering',
            percentage: 0.07,
            icon: Icons.psychology,
            color: kPrimaryPurple,
            isLarge: true,
          ),
          LearningHubCard(
            title: 'FutuyeniWed Conse Hackeholton',
            percentage: 0.88,
            icon: Icons.book,
            color: kAccentTeal,
          ),
          LearningHubCard(
            title: 'Mastering Prompt Engineering',
            percentage: 0.07,
            icon: Icons.psychology,
            color: kPrimaryPurple,
          ),
        ],
      ),
    );
  }

  // --- BLOGS & ARTICLES ---
  Widget _buildBlogsAndArticles() {
    return Column(
      children: const [
        BlogArticleCard(
          title: 'Haminlo',
          subtitle: 'Lapea Vsin dolon lbsonads yan wligar hiot Talar',
          authorName: 'Haminlo',
          tagColor: kAccentTeal,
          tagLabel: '#3 Teples',
        ),
        BlogArticleCard(
          title: 'Moock',
          subtitle: 'Lapea Vsin dolon lbsonads yan wligar hiot Talar',
          authorName: 'Moock',
          tagColor: kPrimaryPurple,
          tagLabel: 'AI',
        ),
        BlogArticleCard(
          title: 'Career',
          subtitle: 'Frigee vrin doloniaads Diaods Kioilay',
          authorName: 'Career',
          tagColor: kAccentPink,
          tagLabel: 'AI',
        ),
      ],
    );
  }
}