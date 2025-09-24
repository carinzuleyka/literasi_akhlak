import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/artikel_model.dart';
import '../models/user_model.dart';
import '../models/kategori_model.dart';
import '../services/api_service.dart';
import 'notification_screen.dart';
import 'category_screen.dart' as Category;
import 'create_article_screen.dart';
import 'video_screen.dart' as Video;
import 'profile_screen.dart' as Profile;
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  User? _user;
  late Future<List<Artikel>> _timelineFuture;
  late Future<List<Kategori>> _kategoriFuture;
  String _selectedCategory = 'Semua';
  int _selectedIndex = 0;
  
  // Animation controller untuk smooth transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  static final List<Widget> _screens = <Widget>[
    const Placeholder(),
    const Category.CategoryScreen(),
    const CreateArticleScreen(),
    const Video.VideoScreen(),
    const Profile.ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _initializeAnimations();
    _loadInitialData();
  }

  void _initializeAnimations() {
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

  Future<void> _loadInitialData() async {
    final savedUser = await ApiService.getSavedUser();
    if (mounted) {
      setState(() {
        _user = savedUser;
        _timelineFuture = ApiService.fetchTimelineArticles();
        _kategoriFuture = ApiService.fetchCategories();
      });
    }
  }

  Future<void> _refreshTimeline() async {
    setState(() {
      _timelineFuture = ApiService.fetchTimelineArticles();
      _kategoriFuture = ApiService.fetchCategories();
    });
  }

  void _handleLike(Artikel artikel) {
    setState(() {
      artikel.isLiked = !artikel.isLiked;
      artikel.isLiked ? artikel.jumlahSuka++ : artikel.jumlahSuka--;
    });

    ApiService.toggleInteraction(artikel.id, 'suka').catchError((e) {
      setState(() {
        artikel.isLiked = !artikel.isLiked;
        artikel.isLiked ? artikel.jumlahSuka++ : artikel.jumlahSuka--;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyukai artikel'), backgroundColor: Colors.red),
      );
    });
  }

  void _handleBookmark(Artikel artikel) {
    setState(() => artikel.isBookmarked = !artikel.isBookmarked);
    ApiService.toggleInteraction(artikel.id, 'bookmark').catchError((e) {
      setState(() => artikel.isBookmarked = !artikel.isBookmarked);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan artikel'), backgroundColor: Colors.red),
      );
    });
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString).toLocal();
      return DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Helper methods for design consistency
  IconData _getIconByType(String? kategoriNama) {
    if (kategoriNama == null) return Icons.article;
    
    switch (kategoriNama.toLowerCase()) {
      case 'buku':
      case 'resensi buku':
        return Icons.menu_book;
      case 'video':
      case 'video dakwah':
        return Icons.play_circle_fill;
      case 'kisah':
      case 'kisah teladan':
        return Icons.auto_stories;
      default:
        return Icons.article;
    }
  }

  Color _getCategoryColor(String? kategoriNama) {
    if (kategoriNama == null) return const Color(0xFF2196F3);
    
    switch (kategoriNama.toLowerCase()) {
      case 'buku':
      case 'resensi buku':
        return const Color(0xFF4CAF50);
      case 'video':
      case 'video dakwah':
        return const Color(0xFFE53935);
      case 'kisah':
      case 'kisah teladan':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF2196F3);
    }
  }

  String _getCategoryLabel(String? kategoriNama) {
    if (kategoriNama == null) return 'ARTIKEL';
    
    switch (kategoriNama.toLowerCase()) {
      case 'buku':
      case 'resensi buku':
        return 'BUKU';
      case 'video':
      case 'video dakwah':
        return 'VIDEO';
      case 'kisah':
      case 'kisah teladan':
        return 'KISAH';
      default:
        return 'ARTIKEL';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String greetingName = _user?.nama.split(' ').first ?? 'Siswa';

    return Scaffold(
      backgroundColor: const Color(0xFF4A90E2), // Changed to blue
      body: _selectedIndex == 0
          ? Container(
              color: const Color(0xFF4A90E2),
              child: SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: RefreshIndicator(
                    onRefresh: _refreshTimeline,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              _buildHeader(greetingName),
                              _buildCategoryFilters(),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: const SizedBox(height: 16),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            color: Colors.white,
                            child: const SizedBox(height: 0),
                          ),
                        ),
                        _buildArticleTimeline(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
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
            selectedItemColor: const Color(0xFF4A90E2), // Changed to blue
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

  Widget _buildHeader(String greetingName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selamat Pagi, $greetingName',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
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
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari Artikel',
                hintStyle: const TextStyle(
                  color: Color(0xFF999999),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF999999),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: FutureBuilder<List<Kategori>>(
        future: _kategoriFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();

          final allCategories = [
            Kategori(id: 0, nama: 'Semua', jumlahArtikel: 0, deskripsi: null),
            ...snapshot.data!
          ];

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              final category = allCategories[index];
              final isSelected = _selectedCategory == category.nama;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category.nama;
                      // TODO: Implement filter logic
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category.nama,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF1976D2) : Colors.white, // Changed to blue
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildArticleTimeline() {
    return FutureBuilder<List<Artikel>>(
      future: _timelineFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white,
                height: 400,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                  ),
                ),
              ),
            ]),
          );
        }
        if (snapshot.hasError) {
          return SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white,
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Terjadi kesalahan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${snapshot.error}',
                        style: TextStyle(color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SliverList(
            delegate: SliverChildListDelegate([
              Container(
                color: Colors.white,
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada artikel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Artikel akan muncul di sini',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          );
        }

        final artikels = snapshot.data!;
        return SliverList(
          delegate: SliverChildListDelegate([
            Container(
              color: Colors.white,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                ),
                itemCount: artikels.length,
                itemBuilder: (context, index) => _buildContentCard(artikels[index]),
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget _buildContentCard(Artikel item) {
    final Map<String, dynamic> articleData = {
      'title': item.judul,
      'username': item.penulis.nama ?? 'Unknown',
      'description': item.isi ?? 'Tidak ada konten tersedia',
      'id': item.id,
    };

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: articleData),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Cover image with fallback
                      item.gambarUrl != null && item.gambarUrl!.isNotEmpty
                          ? Image.network(
                              item.gambarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultCover(item.kategoriNama);
                              },
                            )
                          : _buildDefaultCover(item.kategoriNama),
                      
                      // Category badge
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(item.kategoriNama).withOpacity(0.9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _getCategoryLabel(item.kategoriNama),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      
                      // Bookmark icon
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _handleBookmark(item),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              size: 16,
                              color: item.isBookmarked ? const Color(0xFF4A90E2) : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Content Area
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      item.judul,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1a1a1a),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    
                    // Author
                    Text(
                      item.penulis.nama,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    
                    // Date
                    Text(
                      _formatDate(item.createdAt),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF888888),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Action buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Like button
                        GestureDetector(
                          onTap: () => _handleLike(item),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                item.isLiked ? Icons.favorite : Icons.favorite_border,
                                size: 14,
                                color: item.isLiked ? Colors.red : Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${item.jumlahSuka}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Comment count
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.mode_comment_outlined,
                              size: 12,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '0',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultCover(String? kategoriNama) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF4A90E2).withOpacity(0.8),
            const Color(0xFF64B5F6).withOpacity(0.6),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIconByType(kategoriNama),
            size: 32,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Text(
            _getCategoryLabel(kategoriNama),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}