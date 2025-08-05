import 'package:flutter/material.dart';
import 'notification_screen.dart';
import 'profile_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BacainSebelas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int selectedCategoryIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 0; 
  final List<String> categories = [
    'Semua',
    'Artikel',
    'Resensi Buku',
    'Resensi Film',
  ];

  final Map<String, List<Map<String, dynamic>>> categoryData = {
    'Semua': [
      {
        'type': 'article',
        'username': 'Kriston Watson',
        'title': 'Teknik Smash Terbaik dalam Bola Voli Professional',
        'imageUrl':
            'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=500&h=300&fit=crop',
        'rating': 4.8,
        'time': '2 jam lalu',
        'description':
            'Pelajari teknik smash yang digunakan oleh pemain profesional untuk meningkatkan performa permainan bola voli Anda...',
        'likes': 245,
        'comments': 42,
        'readTime': '5 min',
        'isLiked': false,
      },
      {
        'type': 'text',
        'username': 'Sarah Johnson',
        'time': '4 jam lalu',
        'content':
            'Baru saja menyelesaikan buku "Atomic Habits" dan wow! Sangat merekomendasikan untuk yang ingin membangun kebiasaan baik. Ada yang sudah baca?',
        'likes': 89,
        'comments': 23,
        'isLiked': false,
      },
    ],
    'Resensi Buku': [
      {
        'type': 'article',
        'username': 'Ustadz Ahmad Fadil',
        'title': 'Review: "Akhlak Mulia" - Panduan Membangun Karakter Islami',
        'imageUrl':
            'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=500&h=300&fit=crop',
        'rating': 4.9,
        'time': '1 jam lalu',
        'description':
            'Buku yang mengulas pentingnya akhlak dalam kehidupan sehari-hari berdasarkan Al-Quran dan Hadits. Sangat praktis untuk diterapkan.',
        'likes': 456,
        'comments': 128,
        'readTime': '8 min',
        'isLiked': false,
      },
    ],
    'Resensi Film': [
      {
        'type': 'article',
        'username': 'Michael Chen',
        'title': 'Review Film "Dune: Part Two" - Epik Sci-Fi yang Memukau',
        'imageUrl':
            'https://images.unsplash.com/photo-1489599511024-2d9b2b97c3ab?w=500&h=300&fit=crop',
        'rating': 4.6,
        'time': '2 jam lalu',
        'description':
            'Denis Villeneuve berhasil menyajikan adaptasi yang luar biasa dari novel Frank Herbert...',
        'likes': 178,
        'comments': 67,
        'readTime': '8 min',
        'isLiked': false,
      },
      {
        'type': 'article',
        'username': 'Sari Indah',
        'title': 'Review: "Oppenheimer" - Drama Biografi yang Mendalam',
        'imageUrl':
            'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=500&h=300&fit=crop',
        'rating': 4.8,
        'time': '4 jam lalu',
        'description':
            'Christopher Nolan kembali menghadirkan film yang complex namun brilliant tentang sang bapak bom atom.',
        'likes': 234,
        'comments': 89,
        'readTime': '9 min',
        'isLiked': false,
      },
      {
        'type': 'text',
        'username': 'Rio Pratama',
        'time': '6 jam lalu',
        'content':
            'Baru nonton "Everything Everywhere All at Once" dan... speechless! 🎬✨ Film yang benar-benar out of the box. Rating: 10/10!',
        'likes': 167,
        'comments': 45,
        'isLiked': false,
      },
    ],
    'Olahraga': [
      {
        'type': 'article',
        'username': 'Kriston Watson',
        'title': 'Teknik Smash Terbaik dalam Bola Voli Professional',
        'imageUrl':
            'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=500&h=300&fit=crop',
        'rating': 4.8,
        'time': '2 jam lalu',
        'description':
            'Pelajari teknik smash yang digunakan oleh pemain profesional untuk meningkatkan performa permainan bola voli Anda...',
        'likes': 245,
        'comments': 42,
        'readTime': '5 min',
        'isLiked': false,
      },
      {
        'type': 'article',
        'username': 'Ahmad Fajar',
        'title': 'Tips Meningkatkan Stamina untuk Lari Marathon',
        'imageUrl':
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=500&h=300&fit=crop',
        'rating': 4.5,
        'time': '5 jam lalu',
        'description':
            'Program latihan sistematis untuk mempersiapkan diri mengikuti marathon dengan performa terbaik.',
        'likes': 189,
        'comments': 56,
        'readTime': '6 min',
        'isLiked': false,
      },
    ],
    'Teknologi': [
      {
        'type': 'article',
        'username': 'Tech Guru',
        'title': 'AI Revolution: Dampak ChatGPT terhadap Dunia Kerja',
        'imageUrl':
            'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=500&h=300&fit=crop',
        'rating': 4.7,
        'time': '1 jam lalu',
        'description':
            'Analisis mendalam tentang bagaimana AI mengubah landscape pekerjaan dan skill yang perlu disiapkan.',
        'likes': 456,
        'comments': 128,
        'readTime': '12 min',
        'isLiked': false,
      },
      {
        'type': 'text',
        'username': 'Developer Indo',
        'time': '3 jam lalu',
        'content':
            'Flutter 3.19 baru keluar dengan performance improvements yang significant! 🚀 Ada yang udah coba?',
        'likes': 234,
        'comments': 67,
        'isLiked': false,
      },
    ],
  };

  List<Map<String, dynamic>> get filteredArticles {
    String selectedCategory = categories[selectedCategoryIndex];
    return categoryData[selectedCategory] ?? [];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleLike(int index) {
    setState(() {
      filteredArticles[index]['isLiked'] = !filteredArticles[index]['isLiked'];
      if (filteredArticles[index]['isLiked']) {
        filteredArticles[index]['likes']++;
      } else {
        filteredArticles[index]['likes']--;
      }
    });
  }

  void _showCommentsModal(int index) {
    final article = filteredArticles[index];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsModal(
        username: article['username'],
        title: article['title'] ?? article['content'],
        comments: article['comments'],
        onAddComment: () {
          setState(() {
            filteredArticles[index]['comments']++;
          });
        },
      ),
    );
  }

  Widget buildCategoryTab(String label, int index) {
    bool isActive = selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategoryIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isActive ? null : Colors.grey[200],
          borderRadius: BorderRadius.circular(25),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[700],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Posting - handle create post
      _showCreatePostDialog();
      return;
    }
    
    setState(() {
      _selectedIndex = index;
    });
    
    if (index == 4) { // Profile tab
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      ).then((_) {
        setState(() {});
      });
    }
    // TODO: Implement navigation for other tabs (Buku, Video)
  }

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Buat Postingan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildCreatePostOption(
                    icon: Icons.article_outlined,
                    title: 'Artikel',
                    subtitle: 'Tulis artikel atau review',
                    color: const Color(0xFF4A90E2),
                  ),
                  _buildCreatePostOption(
                    icon: Icons.menu_book_outlined,
                    title: 'Resensi Buku',
                    subtitle: 'Review buku favorit',
                    color: const Color(0xFF34C759),
                  ),
                  _buildCreatePostOption(
                    icon: Icons.movie_outlined,
                    title: 'Resensi Film',
                    subtitle: 'Review film terbaru',
                    color: const Color(0xFFFF9500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreatePostOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        // TODO: Navigate to create post screen based on type
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.auto_awesome,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'BacainSebelas',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const NotificationScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Stack(
                                      children: [
                                        const Icon(
                                          Icons.notifications_none,
                                          size: 24,
                                          color: Colors.white,
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 16,
                                              minHeight: 16,
                                            ),
                                            child: const Text(
                                              '3',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                                    ).then((_) {
                                      setState(() {});
                                    });
                                  },
                                  child: const CircleAvatar(
                                    radius: 20,
                                    backgroundImage: NetworkImage(
                                      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Cari artikel, topik, atau penulis...',
                              hintStyle: TextStyle(color: Colors.grey[600]),
                              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                              suffixIcon: Icon(Icons.filter_list, color: Colors.grey[600]),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Kategori',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Implement "Lihat Semua" functionality
                              },
                              child: const Text('Lihat Semua'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return buildCategoryTab(categories[index], index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedCategoryIndex == 0
                                  ? 'Artikel Terbaru'
                                  : '${categories[selectedCategoryIndex]}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            Text(
                              '${filteredArticles.length} artikel ditemukan',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // TODO: Implement grid view
                              },
                              icon: const Icon(Icons.grid_view),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: Implement list view
                              },
                              icon: const Icon(Icons.view_list),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final articleIndex = index ~/ 2;
                        if (index.isOdd) {
                          return const SizedBox(height: 16);
                        }
                        if (articleIndex >= filteredArticles.length) {
                          return null;
                        }
                        final article = filteredArticles[articleIndex];

                        if (article['type'] == 'article') {
                          return ArticleCard(
                            username: article['username'],
                            title: article['title'],
                            imageUrl: article['imageUrl'],
                            rating: article['rating'],
                            time: article['time'],
                            description: article['description'],
                            likes: article['likes'],
                            comments: article['comments'],
                            readTime: article['readTime'],
                            isLiked: article['isLiked'],
                            isClickable: categories[selectedCategoryIndex] == 'Resensi Film' ||
                                categories[selectedCategoryIndex] == 'Olahraga',
                            onLike: () => _toggleLike(articleIndex),
                            onComment: () => _showCommentsModal(articleIndex),
                          );
                        } else {
                          return ArticleTextCard(
                            username: article['username'],
                            time: article['time'],
                            content: article['content'],
                            likes: article['likes'],
                            comments: article['comments'],
                            isLiked: article['isLiked'],
                            isClickable: categories[selectedCategoryIndex] == 'Resensi Film' ||
                                categories[selectedCategoryIndex] == 'Olahraga',
                            onLike: () => _toggleLike(articleIndex),
                            onComment: () => _showCommentsModal(articleIndex),
                          );
                        }
                      },
                      childCount: filteredArticles.length * 2 - 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF4A90E2),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          elevation: 0,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Buku',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 32),
              activeIcon: Icon(Icons.add_circle, size: 32),
              label: 'Posting',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              activeIcon: Icon(Icons.play_circle),
              label: 'Video',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

class CommentsModal extends StatefulWidget {
  final String username;
  final String title;
  final int comments;
  final VoidCallback onAddComment;

  const CommentsModal({
    Key? key,
    required this.username,
    required this.title,
    required this.comments,
    required this.onAddComment,
  }) : super(key: key);

  @override
  State<CommentsModal> createState() => _CommentsModalState();
}

class _CommentsModalState extends State<CommentsModal> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _commentsList = [
    {
      'username': 'Bayu Resnadi',
      'comment': 'Ini Adalah Contoh Teknik Smash Olahraga Bola Voli',
      'time': '2 jam',
      'likes': 2,
      'isLiked': false,
    },
    {
      'username': 'Akmal Zains',
      'comment': 'Ini Adalah Contoh Teknik Smash Olahraga Bola Voli',
      'time': '1 jam',
      'likes': 2,
      'isLiked': false,
    },
  ];

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _commentsList.insert(0, {
          'username': 'You',
          'comment': _commentController.text.trim(),
          'time': 'Sekarang',
          'likes': 0,
          'isLiked': false,
        });
      });
      _commentController.clear();
      widget.onAddComment();
    }
  }

  void _toggleCommentLike(int index) {
    setState(() {
      _commentsList[index]['isLiked'] = !_commentsList[index]['isLiked'];
      if (_commentsList[index]['isLiked']) {
        _commentsList[index]['likes']++;
      } else {
        _commentsList[index]['likes']--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: const Text(
              'Komentar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Comments list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _commentsList.length,
              itemBuilder: (context, index) {
                final comment = _commentsList[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              comment['username'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              comment['comment'],
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              comment['time'],
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          InkWell(
                            onTap: () => _toggleCommentLike(index),
                            child: Icon(
                              comment['isLiked'] ? Icons.favorite : Icons.favorite_border,
                              size: 20,
                              color: comment['isLiked'] ? Colors.red : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment['likes'].toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Comment input
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Tambahkan Komentar Anda',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Color(0xFF4A90E2)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _addComment,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A90E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
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

class ArticleDetailScreen extends StatelessWidget {
  final String username;
  final String time;
  final String title;
  final String? imageUrl;
  final double? rating;
  final String description;
  final int likes;
  final int comments;
  final String? readTime;
  final bool isTextOnly;

  const ArticleDetailScreen({
    Key? key,
    required this.username,
    required this.time,
    this.title = '',
    this.imageUrl,
    this.rating,
    required this.description,
    required this.likes,
    required this.comments,
    this.readTime,
    required this.isTextOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isTextOnly ? 'Text Post' : 'Article Detail'),
        backgroundColor: const Color(0xFF4A90E2),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                    ),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          time,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isTextOnly && rating != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (!isTextOnly && imageUrl != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                            ),
                          );
                        },
                      ),
                    ),
                    if (readTime != null)
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            readTime!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 16),
              if (!isTextOnly)
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                    height: 1.3,
                  ),
                ),
              if (!isTextOnly) const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildActionButton(Icons.favorite_border, likes.toString()),
                  const SizedBox(width: 24),
                  _buildActionButton(Icons.chat_bubble_outline, comments.toString()),
                  const SizedBox(width: 24),
                  _buildActionButton(Icons.share_outlined, 'Bagikan'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {
        // TODO: Implement action button functionality
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final String username;
  final String time;
  final String title;
  final String imageUrl;
  final double rating;
  final String description;
  final int likes;
  final int comments;
  final String readTime;
  final bool isClickable;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const ArticleCard({
    Key? key,
    required this.username,
    required this.time,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.description,
    required this.likes,
    required this.comments,
    required this.readTime,
    this.isClickable = false,
    required this.isLiked,
    required this.onLike,
    required this.onComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    readTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                      ),
                      radius: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildActionButton(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      likes.toString(),
                      isLiked ? Colors.red : Colors.grey[600]!,
                      onLike,
                    ),
                    const SizedBox(width: 24),
                    _buildActionButton(
                      Icons.chat_bubble_outline,
                      comments.toString(),
                      Colors.grey[600]!,
                      onComment,
                    ),
                    const SizedBox(width: 24),
                    _buildActionButton(
                      Icons.share_outlined,
                      'Bagikan',
                      Colors.grey[600]!,
                      () {},
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        // TODO: Implement bookmark functionality
                      },
                      icon: const Icon(Icons.bookmark_border),
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (isClickable) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(
                username: username,
                time: time,
                title: title,
                imageUrl: imageUrl,
                rating: rating,
                description: description,
                likes: likes,
                comments: comments,
                readTime: readTime,
                isTextOnly: false,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: card,
      );
    }
    return card;
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleTextCard extends StatelessWidget {
  final String username;
  final String time;
  final String content;
  final int likes;
  final int comments;
  final bool isClickable;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;

  const ArticleTextCard({
    Key? key,
    required this.username,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
    this.isClickable = false,
    required this.isLiked,
    required this.onLike,
    required this.onComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
                ),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Implement more options
                },
                icon: Icon(Icons.more_horiz, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildActionButton(
                isLiked ? Icons.favorite : Icons.favorite_border,
                likes.toString(),
                isLiked ? Colors.red : Colors.grey[600]!,
                onLike,
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                Icons.chat_bubble_outline,
                comments.toString(),
                Colors.grey[600]!,
                onComment,
              ),
              const SizedBox(width: 24),
              _buildActionButton(
                Icons.share_outlined,
                'Bagikan',
                Colors.grey[600]!,
                () {},
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // TODO: Implement bookmark functionality
                },
                icon: const Icon(Icons.bookmark_border),
                color: Colors.grey[600],
              ),
            ],
          ),
        ],
      ),
    );

    if (isClickable) {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(
                username: username,
                time: time,
                description: content,
                likes: likes,
                comments: comments,
                isTextOnly: true,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: card,
      );
    }
    return card;
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}