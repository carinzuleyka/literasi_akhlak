import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart'; // <-- Import AuthScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Mate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const OnboardingScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/auth': (context) => const AuthScreen(), // <-- Tambahkan ini
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Placeholder home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Mate'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Social Mate!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
