import 'package:flutter/material.dart';

// Placeholder classes to prevent compilation errors
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: const Center(child: Text('Halaman Profil (Placeholder)')),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: const Center(child: Text('Halaman Notifikasi (Placeholder)')),
    );
  }
}

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategori')),
      body: const Center(child: Text('Halaman Kategori (Placeholder)')),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;
  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article['title'])),
      body: Center(child: Text('Detail Artikel (Placeholder) untuk: ${article['title']}')),
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
      appBar: AppBar(title: Text(categoryName)),
      body: Center(child: Text('Detail Kategori (Placeholder) untuk: $categoryName')),
    );
  }
}

class CreatePostBottomSheet extends StatelessWidget {
  const CreatePostBottomSheet({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: const Center(
        child: Text('Create Post Modal (Placeholder)'),
      ),
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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> categories = [
    'Semua',
    'Artikel',
    'Resensi Buku',
    'Resensi Film',
  ];

  final List<Map<String, dynamic>> categoryItems = [
    {
      'icon': Icons.sports_tennis,
      'title': 'Olahraga',
      'count': 89,
      'color': const Color(0xFF4CAF50),
    },
    {
      'icon': Icons.checkroom,
      'title': 'Fashion',
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

  final Map<String, List<Map<String, dynamic>>> categoryData = {
    'Semua': [
      {
        'type': 'book_review',
        'username': 'Kristen Watson',
        'title': 'Atomic Habits - Panduan Membangun Kebiasaan Baik',
        'author': 'James Clear',
        'imageUrl': 'https://m.media-amazon.com/images/I/51B7kuGwKVL._SY580_.jpg',
        'rating': 5.0,
        'comments': 56,
        'category': 'Resensi Buku',
        'description': 'Buku yang memberikan panduan praktis untuk membangun kebiasaan baik dan menghilangkan kebiasaan buruk melalui perubahan kecil namun konsisten.',
      },
      {
        'type': 'tips',
        'username': 'Milkaus',
        'title': 'Tips Meningkatkan Performa Badminton Untuk Pemula',
        'imageUrl': 'https://images.unsplash.com/photo-1544737151-6e4b01dce556?w=500&h=300&fit=crop',
        'rating': 5.0,
        'comments': 34,
        'category': 'Tips & Trik',
        'description': 'Panduan lengkap untuk pemula yang ingin meningkatkan skill badminton dengan teknik dasar yang benar.',
      },
      {
        'type': 'article',
        'username': 'Sarah',
        'title': 'Review buku: ATOMIC HABITS',
        'imageUrl': 'https://assets.telkomsel.com/public/2024-10/buku%20atomic%20habits.png',
        'rating': 4.5,
        'time': '4 jam lalu',
        'description': 'Atomic Habits karya James Clear menjelaskan cara membentuk kebiasaan baik melalui perubahan kecil namun konsisten.',
        'likes': 89,
        'comments': 23,
        'readTime': '5 min',
        'isLiked': false,
      },
    ],
    'Artikel': [
      {
        'type': 'article',
        'username': 'John Doe',
        'title': 'Cara Efektif Belajar Online di Era Digital',
        'imageUrl': 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=500&h=300&fit=crop',
        'rating': 4.8,
        'comments': 42,
        'category': 'Edukasi',
        'description': 'Tips dan strategi untuk memaksimalkan pembelajaran online dengan berbagai platform dan tools yang tersedia.',
      },
    ],
    'Resensi Buku': [
      {
        'type': 'book_review',
        'username': 'Book Lover',
        'title': 'The 7 Habits of Highly Effective People',
        'author': 'Stephen Covey',
        'imageUrl': 'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1421842784i/36072.jpg',
        'rating': 4.9,
        'comments': 78,
        'category': 'Resensi Buku',
        'description': 'Buku klasik tentang pengembangan diri yang mengajarkan 7 kebiasaan untuk mencapai efektivitas dalam kehidupan.',
      },
    ],
    'Resensi Film': [
      {
        'type': 'movie_review',
        'username': 'Movie Critic',
        'title': 'Spider-Man: No Way Home - Review Lengkap',
        'imageUrl': 'https://images.unsplash.com/photo-1594736797933-d0803ba2fe65?w=500&h=300&fit=crop',
        'rating': 4.7,
        'comments': 156,
        'category': 'Resensi Film',
        'description': 'Review mendalam tentang film Spider-Man terbaru dengan multiverse yang spektakuler dan nostalgia yang mengena.',
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
        // Corrected navigation to VideoScreen
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
        return const CreatePostBottomSheet();
      },
    ).catchError((e) {
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

  Widget _buildCategoryItem(Map<String, dynamic> item, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailScreen(
              categoryName: item['title'],
              categoryIcon: item['icon'],
              categoryColor: item['color'],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF7ED6A8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              item['icon'],
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              item['title'],
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (item['count'] > 0) ...[
              const SizedBox(height: 4),
              Text(
                '${item['count']}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookReviewCard(Map<String, dynamic> item) {
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      item['category'] ?? 'Resensi Buku',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF9800),
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
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1494790108755-2616b612b47c?w=150&h=150&fit=crop&crop=face',
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
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            size: 16,
                            color: index < (item['rating'] ?? 0) ? Colors.amber : Colors.grey[300],
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
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
            const SizedBox(width: 16),
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item['imageUrl'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.book, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard(Map<String, dynamic> item) {
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
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item['category'] ?? 'Tips & Trik',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
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
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
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
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              size: 16,
                              color: index < (item['rating'] ?? 0) ? Colors.amber : Colors.grey[300],
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
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
            ),
            Container(
              width: 120,
              height: 120,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF7ED6A8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item['imageUrl'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF7ED6A8),
                            const Color(0xFF4CAF50),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.sports_tennis,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              ),
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
                        Row(
                          children: [
                            const Text(
                              'Selamat Pagi, Deewi',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFC107),
                                shape: BoxShape.circle,
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
                                child: const Icon(
                                  Icons.notifications_none,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
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
                          hintText: 'Cari Artikel',
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Kategori',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: categoryItems.length,
                          itemBuilder: (context, index) {
                            return _buildCategoryItem(categoryItems[index], index);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredArticles.length,
                          itemBuilder: (context, index) {
                            final article = filteredArticles[index];

                            if (article['type'] == 'book_review') {
                              return _buildBookReviewCard(article);
                            } else if (article['type'] == 'tips') {
                              return _buildTipsCard(article);
                            } else {
                              return Container(
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
                                    Text(
                                      article['title'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      article['description'] ?? '',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
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
          title: const Text('Filter Artikel'),
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