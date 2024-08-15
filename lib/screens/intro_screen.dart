import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _introData = [
    {'title': 'Dashboard', 'icon': 'assets/dash.json'},
    {'title': 'Map View', 'icon': 'assets/map.json'},
    {'title': 'Profile', 'icon': 'assets/profile.json'},
    {'title': 'Reports', 'icon': 'assets/reports.json'},
    {'title': 'Track by Criteria', 'icon': 'assets/trackc.json'},
    {'title': 'Track by Vehicle', 'icon': 'assets/trackbyv.json'},
    {'title': 'Live Tracking', 'icon': 'assets/live.json'},
  ];

  void _onNextPressed() {
    if (_currentPage < _introData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(onLoginSuccess: () {})), // Placeholder callback
      );
    }
  }

  void _onPreviousPressed() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff25D366), Color(0xFFA5D6A7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: _introData.length,
                  itemBuilder: (context, index) {
                    return _buildIntroSlide(
                      title: _introData[index]['title']!,
                      animationPath: _introData[index]['icon']!,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: _onPreviousPressed,
                      icon: const Icon(Icons.arrow_back),
                      color: _currentPage > 0 ? Colors.black : Colors.grey,
                    ),
                    ElevatedButton(
                      onPressed: _onNextPressed,
                      child: Text(_currentPage == _introData.length - 1 ? 'Done' : 'Next'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIntroSlide({required String title, required String animationPath}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedHeader(title: title),
        const SizedBox(height: 20),
        Lottie.asset(animationPath, width: 200, height: 200),
      ],
    );
  }
}

class AnimatedHeader extends StatelessWidget {
  final String title;

  const AnimatedHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
