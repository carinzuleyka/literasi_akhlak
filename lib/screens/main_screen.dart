import 'package:flutter/material.dart';
import 'home_screens.dart' as Home; // Pastikan nama file sesuai
import 'category_screen.dart' as Category;
import 'create_article_screen.dart';
import 'video_screen.dart' as Video;
import 'profile_screen.dart' as Profile;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Daftar semua layar utama
  static final List<Widget> _screens = <Widget>[
    const Home.HomeScreen(),
    const Category.CategoryScreen(),
    const CreateArticleScreen(),
    const Video.VideoScreen(),
    const Profile.ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: const Color(0xFF7ED6A8),
            unselectedItemColor: Colors.grey[500],
            backgroundColor: Colors.white,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 24),
                activeIcon: Icon(Icons.home, size: 24),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apps, size: 24),
                activeIcon: Icon(Icons.apps, size: 24),
                label: 'Kategori',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline, size: 24),
                activeIcon: Icon(Icons.add_circle, size: 24),
                label: 'Posting',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.play_circle_outline, size: 24),
                activeIcon: Icon(Icons.play_circle, size: 24),
                label: 'Video',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 24),
                activeIcon: Icon(Icons.person, size: 24),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}