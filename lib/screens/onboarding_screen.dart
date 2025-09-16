// lib/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/onboarding_data.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Fungsi ini dijalankan saat onboarding selesai
  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    // Simpan status bahwa onboarding telah selesai ditampilkan
    await prefs.setBool('hasSeenOnboarding', true);
    
    if(mounted) {
      // Arahkan ke halaman otentikasi
      Navigator.of(context).pushReplacementNamed('/auth');
    }
  }

  // Fungsi untuk tombol 'Selanjutnya' atau 'Masuk'
  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Jika ini adalah halaman terakhir, panggil _finishOnboarding
      _finishOnboarding();
    }
  }

  // Fungsi untuk tombol 'Skip'
  void _skipToEnd() {
    _finishOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Tombol Skip
            if (_currentPage < onboardingPages.length - 1)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _skipToEnd,
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              )
            else
              const SizedBox(height: 56), // Placeholder agar layout konsisten
            
            // PageView untuk halaman onboarding
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardingPages.length,
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(
                    data: onboardingPages[index],
                    isFirstPage: index == 0,
                  );
                },
              ),
            ),
            
            // Indikator halaman dan tombol
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  PageIndicator(
                    currentPage: _currentPage,
                    totalPages: onboardingPages.length,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        _currentPage == onboardingPages.length - 1 
                            ? 'Masuk' 
                            : 'Selanjutnya',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}