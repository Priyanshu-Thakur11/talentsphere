
import 'package:flutter/material.dart';
import 'package:nileshapp/starting/gradientbutton.dart';
import 'package:nileshapp/starting/placeholder_screen.dart';

// --- Color Palette and Constants ---
const Color kDarkBackground = Color(0xFF0C091D);
const Color kCardColor = Color(0xFF1B1832);
const Color kPrimaryPurple = Color(0xFF9370DB); 
const Color kAccentTeal = Color(0xFF20C9A5);
const Color kAccentPink = Color(0xFFF790D8);
const Color kTextSecondary = Color(0xFFAAAAAA);

const double kCardRadius = 20.0;
const double kGlowSpread = 2.0;

class OnboardingContent {
  final String title;
  final String subtitle;
  final String imagePath; // Used as a key for the PlaceholderImage
  final Widget imageWidget;

  OnboardingContent({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.imageWidget,
  });
}

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onGetStarted;

  const OnboardingScreen({super.key, required this.onGetStarted});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> content = [
    OnboardingContent(
      title: 'Smart AI Matchmaking',
      subtitle: 'Effortlessly connect with the best talent or projects.',
      imagePath: 'ai_matchmaking',
      imageWidget: const PlaceholderImage(
        assetKey: 'ai_matchmaking',
        size: 250,
      ),
    ),
    OnboardingContent(
      title: 'Hire or Join Teams',
      subtitle: 'Find your perfect role or build your dream team.',
      imagePath: 'hire_join_teams',
      imageWidget: const PlaceholderImage(
        assetKey: 'hire_join_teams',
        size: 250,
      ),
    ),
    OnboardingContent(
      title: 'Collaborate Seamlessly',
      subtitle: 'Chat, manage tasks, and share feedback or projects effortlessly.',
      imagePath: 'collaborate',
      imageWidget: const PlaceholderImage(
        assetKey: 'collaborate',
        size: 250,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackground,
      body: Stack(
        children: [
          // Background for Onboarding is simpler (just the dark background)
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: widget.onGetStarted,
                child: Text('Skip', style: TextStyle(color: kTextSecondary.withOpacity(0.8), fontSize: 16)),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: content.length,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 2),
                          content[index].imageWidget,
                          const Spacer(flex: 1),
                          Text(
                            content[index].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            content[index].subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: kTextSecondary,
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(flex: 2),
                          _currentPage == content.length - 1
                              ? GradientButton(
                                  text: 'Get Started',
                                  onPressed: widget.onGetStarted,
                                )
                              : GradientButton(
                                  text: 'Next',
                                  onPressed: () {
                                    _pageController.nextPage(
                                      duration: const Duration(milliseconds: 400),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              content.length,
                              (index) => buildDot(index, context),
                            ),
                          ),
                          const Spacer(flex: 1),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 8,
      width: _currentPage == index ? 24 : 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentPage == index ? kGlowBlue : kTextSecondary.withOpacity(0.4),
      ),
    );
  }
}