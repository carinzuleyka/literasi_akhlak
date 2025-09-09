import 'package:flutter/material.dart';

// Import screens lainnya
import 'profile_screen.dart';
import 'article_detail_screen.dart';
import 'notification_screen.dart';
import 'create_post_screen.dart';
// Import RatingDialog yang baru dibuat
import 'rating_dialog.dart'; // Sesuaikan path file

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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Map untuk menyimpan rating yang diberikan user
  Map<String, double> userRatings = {};

  final List<String> categories = [
    'Semua',
    'Artikel',
    'Resensi Buku',
    'Resensi Film',
  ];

  final List<Map<String, dynamic>> categoryItems = [
    {
      'icon': Icons.article,
      'title': 'Artikel\nAkhlak',
      'count': 89,
      'color': const Color(0xFF4CAF50),
    },
    {
      'icon': Icons.favorite,
      'title': 'Kisah\nTeladan',
      'count': 45,
      'color': const Color(0xFF4CAF50),
    },
    {
      'icon': Icons.more_horiz,
      'title': 'Lainnya',
      'count': 0,
      'color': const Color(0xFF4CAF50),
    },
  ];

  // Data artikel tanpa rating default
  final Map<String, List<Map<String, dynamic>>> categoryData = {
    'Semua': [
      {
        'id': 'article_1',
        'type': 'article',
        'username': 'Ustadz Ahmad Abdullah',
        'title': 'Akhlak Mulia Rasulullah SAW - Teladan Terbaik Umat Manusia',
        'comments': 56,
        'category': 'Kisah Teladan',
        'description': 'Mempelajari akhlak mulia Rasulullah SAW sebagai teladan dalam kehidupan sehari-hari.',
      },
      {
        'id': 'article_2',
        'type': 'article',
        'username': 'Dr. Siti Aisyah',
        'title': 'Pentingnya Adab Dalam Islam - Panduan Praktis',
        'comments': 34,
        'category': 'Artikel Akhlak',
        'description': 'Panduan lengkap tentang adab dan etika dalam Islam untuk kehidupan yang lebih berkah.',
      },
      {
        'id': 'video_1',
        'type': 'video',
        'username': 'Ustadz Muhammad Hafiz',
        'title': 'Ceramah: Berbakti Kepada Orang Tua',
        'time': '2 jam lalu',
        'description': 'Video ceramah tentang pentingnya berbakti kepada orang tua dalam ajaran Islam.',
        'likes': 89,
        'comments': 23,
        'duration': '15 min',
      },
    ],
    'Artikel': [
      {
        'id': 'article_2',
        'type': 'article',
        'username': 'Dr. Siti Aisyah',
        'title': 'Pentingnya Adab Dalam Islam - Panduan Praktis',
        'comments': 42,
        'category': 'Artikel Akhlak',
        'description': 'Panduan lengkap tentang adab dan etika dalam Islam untuk kehidupan yang lebih berkah.',
      },
    ],
    'Kisah Teladan': [
      {
        'id': 'article_1',
        'type': 'article',
        'username': 'Ustadz Ahmad Abdullah',
        'title': 'Akhlak Mulia Rasulullah SAW - Teladan Terbaik Umat Manusia',
        'comments': 78,
        'category': 'Kisah Teladan',
        'description': 'Mempelajari akhlak mulia Rasulullah SAW sebagai teladan dalam kehidupan sehari-hari.',
      },
    ],
    'Video Dakwah': [
      {
        'id': 'video_1',
        'type': 'video',
        'username': 'Ustadz Muhammad Hafiz',
        'title': 'Ceramah: Berbakti Kepada Orang Tua',
        'comments': 156,
        'category': 'Video Dakwah',
        'description': 'Video ceramah tentang pentingnya berbakti kepada orang tua dalam ajaran Islam.',
      },
    ],
    'Resensi Buku': [
      {
        'id': 'book_1',
        'type': 'article',
        'username': 'Ustadz Muhammad Hafiz',
        'title': 'Resensi Buku "Menjadi Hamba yang Dicintai Allah"',
        'comments': 67,
        'category': 'Resensi Buku',
        'description': 'Ulasan mendalam tentang buku yang memberikan panduan praktis untuk mendekatkan diri kepada Allah SWT.',
      },
    ],
    'Resensi Film': [
      {
        'id': 'film_1',
        'type': 'video',
        'username': 'Dr. Siti Aisyah',
        'title': 'Analisis Film "Sang Pencerah" dari Sudut Pandang Akhlak',
        'comments': 112,
        'category': 'Resensi Film',
        'description': 'Kupas tuntas film inspiratif tentang perjuangan pendiri Muhammadiyah.',
      },
    ],
  };

  List<Map<String, dynamic>> get filteredArticles {
    String selectedCategory = categories[selectedCategoryIndex];
    List<Map<String, dynamic>> articles = categoryData[selectedCategory] ?? [];

    if (_searchQuery.isNotEmpty) {
      articles = articles.where((article) {
        String title = article['title']?.toLowerCase() ?? '';
        String username = article['username']?.toLowerCase() ?? '';
        String query = _searchQuery.toLowerCase();

        return title.contains(query) || username.contains(query);
      }).toList();
    }

    return articles;
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
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  // Method untuk menampilkan rating dialog
  void _showRatingDialog(Map<String, dynamic> item) {
    String itemId = item['id'] ?? '';
    double currentRating = userRatings[itemId] ?? 0.0;
    
    context.showRatingDialog(
      title: item['title'] ?? '',
      currentRating: currentRating,
      onRatingSubmitted: (double newRating) {
        setState(() {
          userRatings[itemId] = newRating;
        });
      },
    );
  }

  // Method untuk cek apakah user sudah memberikan rating
  bool _hasUserRating(Map<String, dynamic> item) {
    String itemId = item['id'] ?? '';
    return userRatings.containsKey(itemId) && userRatings[itemId]! > 0;
  }

  // Method untuk mendapatkan rating user
  double _getUserRating(Map<String, dynamic> item) {
    String itemId = item['id'] ?? '';
    return userRatings[itemId] ?? 0.0;
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      _showCreatePostDialog();
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    try {
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoryScreen()),
        ).then((_) {
          setState(() {
            _selectedIndex = 0;
          });
        });
      } else if (index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VideoScreen()),
        ).then((_) {
          setState(() {
            _selectedIndex = 0;
          });
        });
      } else if (index == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        ).then((_) {
          setState(() {
            _selectedIndex = 0;
          });
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCreatePostDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const CreatePostScreen();
      },
    ).then((_) {
      setState(() {
        _selectedIndex = 0;
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening create post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  Widget _buildCategoryChip(String label, int index) {
    bool isSelected = selectedCategoryIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategoryIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(Map<String, dynamic> item) {
    bool hasUserRating = _hasUserRating(item);
    double userRating = _getUserRating(item);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: item['type'] == 'video'
                    ? const Color(0xFFFFEBEE)
                    : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item['category'] ?? 'Artikel',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: item['type'] == 'video'
                      ? const Color(0xFFE53935)
                      : const Color(0xFFFF9800),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  child: Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item['username'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (hasUserRating) ...[
                  // Rating Display - Langsung muncul tanpa tombol edit
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () => _showRatingDialog(item), // Bisa diklik untuk mengubah rating
                          child: Icon(
                            Icons.star,
                            size: 20,
                            color: index < userRating 
                                ? const Color(0xFF7ED6A8)
                                : Colors.grey[300],
                          ),
                        );
                      }),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showRatingDialog(item),
                        child: Text(
                          userRating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF7ED6A8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                ] else ...[
                  // Rating action button - untuk memberikan rating pertama kali
                  GestureDetector(
                    onTap: () => _showRatingDialog(item),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            Icons.star_border,
                            size: 20,
                            color: Colors.grey[400],
                          );
                        }),
                        const SizedBox(width: 8),
                        Text(
                          'Beri Rating',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
                
                // Comments - selalu ada di kanan
                Icon(
                  Icons.chat_bubble_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${item['comments'] ?? 0}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item['description'] ?? '',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7ED6A8),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'BacainSebelas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text('🌟', style: TextStyle(fontSize: 18)),
                          ],
                        ),
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
                            child: const Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Cari Konten Akhlak',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[500],
                            size: 20,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              _showFilterDialog();
                            },
                            child: Icon(
                              Icons.tune,
                              color: Colors.grey[500],
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return _buildCategoryChip(categories[index], index);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredArticles.length,
                          itemBuilder: (context, index) {
                            final article = filteredArticles[index];
                            return _buildContentCard(article);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Filter Konten'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.star, color: Color(0xFF7ED6A8)),
                title: const Text('Rating Tertinggi'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Filter berdasarkan rating diterapkan'),
                      backgroundColor: Color(0xFF7ED6A8),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.access_time, color: Color(0xFF7ED6A8)),
                title: const Text('Terbaru'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Filter terbaru diterapkan'),
                      backgroundColor: Color(0xFF7ED6A8),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.trending_up, color: Color(0xFF7ED6A8)),
                title: const Text('Terpopuler'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Filter terpopuler diterapkan'),
                      backgroundColor: Color(0xFF7ED6A8),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

// Class lainnya tetap sama seperti sebelumnya
class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video')),
      body: const Center(child: Text('Halaman Video (Placeholder)')),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> categories = const [
    {
      'title': 'Artikel Akhlak',
      'count': '245 artikel',
      'description': 'Artikel menarik seputar nilai, sikap, dan pembelajaran kehidupan sehari-hari',
      'icon': Icons.article,
      'color': Colors.blue,
    },
    {
      'title': 'Kisah Teladan',
      'count': '156 kisah',
      'description': 'Cerita inspiratif dari tokoh, sejarah, dan pengalaman yang bisa diambil hikmahnya',
      'icon': Icons.book,
      'color': Colors.orange,
    },
    {
      'title': 'Video Dakwah',
      'count': '89 artikel',
      'description': 'Konten video edukatif dan motivasi yang mudah dipahami dan menyenangkan',
      'icon': Icons.people,
      'color': Colors.green,
    },
    {
      'title': 'Tips & Panduan',
      'count': '134 kisah',
      'description': 'Tips sederhana dan panduan praktis untuk kehidupan sehari-hari',
      'icon': Icons.auto_stories,
      'color': Colors.purple,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Semua Kategori',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryDetailScreen(
                      categoryName: category['title'],
                      categoryIcon: category['icon'],
                      categoryColor: category['color'],
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: (category['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        category['icon'],
                        color: category['color'],
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      category['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      category['count'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['description'],
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;
  const CategoryDetailScreen({
    Key? key,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: categoryColor.withOpacity(0.1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    categoryIcon,
                    size: 48,
                    color: categoryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    categoryName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Konten dalam kategori ini sedang dalam pengembangan',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
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