import 'package:flutter/material.dart';
import '../models/kategori_model.dart';
import '../services/api_service.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin {
  late Future<List<Kategori>> _kategoriFuture;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _kategoriFuture = ApiService.fetchCategories();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Method untuk mendapatkan icon berdasarkan kategori
  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'fiksi':
        return Icons.auto_stories;
      case 'pahlawan':
        return Icons.military_tech;
      case 'sahabat':
        return Icons.people;
      case 'buku':
      case 'resensi buku':
        return Icons.menu_book;
      case 'video':
      case 'video dakwah':
        return Icons.play_circle_fill;
      case 'kisah':
      case 'kisah teladan':
        return Icons.psychology;
      default:
        return Icons.article;
    }
  }

  // Method untuk mendapatkan warna pastel berdasarkan kategori
  Color _getCategoryColor(String categoryName, int index) {
    switch (categoryName.toLowerCase()) {
      case 'fiksi':
        return const Color(0xFFE1BEE7); // Light purple
      case 'pahlawan':
        return const Color(0xFFFFCDD2); // Light red/pink
      case 'sahabat':
        return const Color(0xFFB2EBF2); // Light cyan
      case 'buku':
      case 'resensi buku':
        return const Color(0xFFC8E6C9); // Light green
      case 'video':
      case 'video dakwah':
        return const Color(0xFFFFE0B2); // Light orange
      case 'kisah':
      case 'kisah teladan':
        return const Color(0xFFD1C4E9); // Light deep purple
      default:
        // Fallback untuk kategori lain menggunakan warna biru pastel
        final pastelBlueShades = [
          const Color(0xFFBBDEFB), // Light blue
          const Color(0xFFC5CAE9), // Light indigo
          const Color(0xFFB3E5FC), // Light sky blue
          const Color(0xFFE3F2FD), // Very light blue
        ];
        return pastelBlueShades[index % pastelBlueShades.length];
    }
  }

  // Method untuk mendapatkan warna icon yang kontras dengan background pastel
  Color _getIconColor(String categoryName, int index) {
    switch (categoryName.toLowerCase()) {
      case 'fiksi':
        return const Color(0xFF7B1FA2); // Purple
      case 'pahlawan':
        return const Color(0xFFD32F2F); // Red
      case 'sahabat':
        return const Color(0xFF0097A7); // Cyan
      case 'buku':
      case 'resensi buku':
        return const Color(0xFF388E3C); // Green
      case 'video':
      case 'video dakwah':
        return const Color(0xFFF57C00); // Orange
      case 'kisah':
      case 'kisah teladan':
        return const Color(0xFF512DA8); // Deep purple
      default:
        return const Color(0xFF1976D2); // Blue
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF4A90E2),
              const Color(0xFF64B5F6).withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                // Header yang bisa di-scroll
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),
                // Categories content
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
                    child: _buildCategoriesContent(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align ke kiri
        children: [
          const Text(
            'Semua Kategori',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Jelajahi berbagai kategori artikel menarik',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesContent() {
    return FutureBuilder<List<Kategori>>(
      future: _kategoriFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(50.0),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada kategori',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kategori akan muncul di sini',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final categories = snapshot.data!;
        return GridView.builder(
          shrinkWrap: true, // Important: agar grid tidak mengambil infinite height
          physics: const NeverScrollableScrollPhysics(), // Disable grid scroll, biar parent yang handle
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1, // Membuat card lebih kecil/pendek
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryCard(categories[index], index);
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(Kategori category, int index) {
    final pastelColor = _getCategoryColor(category.nama, index);
    final iconColor = _getIconColor(category.nama, index);
    final icon = _getCategoryIcon(category.nama);

    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman detail kategori
        // Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailScreen(category: category)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header dengan warna pastel
            Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                color: pastelColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  // Background pattern subtle
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Icon
                  Center(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.nama,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1a1a1a),
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: pastelColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${category.jumlahArtikel} artikel',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: iconColor,
                            ),
                          ),
                        ),
                        
                        // Arrow indicator
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: pastelColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: iconColor,
                          ),
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
}