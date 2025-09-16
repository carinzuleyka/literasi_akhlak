// lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_service.dart';
import 'screens/auth_screen.dart';
import 'screens/main_screen.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Literasi Akhlak',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7ED6A8)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // Tentukan rute agar bisa dipanggil dari onboarding
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/main': (context) => const MainScreen(),
      },
      home: const CheckAuth(), // Mulai dari sini
    );
  }
}

// Widget ini akan memeriksa apakah onboarding sudah dilihat atau belum
class CheckAuth extends StatefulWidget {
  const CheckAuth({Key? key}) : super(key: key);

  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool _isLoading = true;
  bool _showOnboarding = true;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    // Cek apakah 'hasSeenOnboarding' bernilai true, defaultnya false
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    
    if (hasSeenOnboarding) {
      // Jika sudah pernah lihat, langsung cek login
      _checkLoginStatus();
    } else {
      // Jika belum pernah lihat, tampilkan onboarding
      setState(() {
        _showOnboarding = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _checkLoginStatus() async {
    final token = await ApiService.getToken();
    if (mounted) {
      if (token != null) {
        Navigator.of(context).pushReplacementNamed('/main');
      } else {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return _showOnboarding ? const OnboardingScreen() : const CheckAuth();
  }
}