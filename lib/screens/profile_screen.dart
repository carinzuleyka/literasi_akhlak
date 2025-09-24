import 'dart:ui'; // <— tambahkan ini untuk ImageFilter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/user_model.dart';
import '../models/artikel_model.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late Future<Map<String, dynamic>> _profileDataFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _tabController = TabController(length: 3, vsync: this);
    _profileDataFuture = _loadInitialProfileData();
  }

  Future<Map<String, dynamic>> _loadInitialProfileData() async {
    try {
      final user = await ApiService.getSavedUser();
      final articles = await ApiService.fetchMyArticles();
      return {'user': user, 'articles': articles};
    } catch (e) {
      throw Exception('Gagal memuat data profil: $e');
    }
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _profileDataFuture = _loadInitialProfileData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString).toLocal();
      return DateFormat('d MMM yyyy', 'id_ID').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data?['user'] == null) {
            return _buildErrorState(snapshot.error?.toString());
          }

          final User user = snapshot.data!['user'] as User;
          final List<Artikel> myArticles =
              snapshot.data!['articles'] as List<Artikel>;

          return _buildProfileView(user, myArticles);
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF6BA3E8),
            Color(0xFF7DB3EA),
          ],
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Memuat profil...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String? error) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF6BA3E8),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 64,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Oops! Terjadi Kesalahan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                error ?? "Gagal memuat profil",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _refreshProfile,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'Coba Lagi',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF4A90E2),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView(User user, List<Artikel> myArticles) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final headerHeight = isSmallScreen ? 280.0 : 320.0; // ✅ REDUCED: 320/360 -> 280/320

        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                expandedHeight: headerHeight,
                floating: false,
                pinned: false,
                stretch: true,
                elevation: 0,
                // ✅ ADD SETTINGS ICON
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 16, top: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        // Handle settings action
                      },
                      icon: const Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildModernProfileHeader(user, myArticles.length, isSmallScreen),
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: _ModernSliverTabDelegate(
                  _buildModernTabBar(isSmallScreen),
                ),
                pinned: true,
              ),
            ];
          },
          body: Container(
            color: const Color(0xFFF5F7FA),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildModernArticleList(Future.value(myArticles)),
                _buildModernArticleList(ApiService.fetchInteractedArticles('suka')),
                _buildModernArticleList(ApiService.fetchInteractedArticles('bookmark')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernProfileHeader(User user, int postCount, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF6BA3E8),
            Color(0xFF7DB3EA),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned(
            top: 0,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 24.0 : 32.0,
                  vertical: 16.0, // ✅ REDUCED: 20 -> 16
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // ✅ ADDED: Prevent overflow
                  children: [
                    const SizedBox(height: 16), // ✅ REDUCED: 20 -> 16
                    // Modern Avatar - SMALLER SIZE
                    Container(
                      padding: const EdgeInsets.all(4), // ✅ REDUCED: 6 -> 4
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.3),
                            Colors.white.withValues(alpha: 0.1),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20, // ✅ REDUCED: 30 -> 20
                            offset: const Offset(0, 10), // ✅ REDUCED: 15 -> 10
                          ),
                        ],
                      ),
                      child: Container(
                        width: isSmallScreen ? 100 : 120, // ✅ REDUCED: 120/140 -> 100/120
                        height: isSmallScreen ? 100 : 120, // ✅ REDUCED: 120/140 -> 100/120
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.9),
                              Colors.white.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            user.nama.isNotEmpty ? user.nama.substring(0, 1).toUpperCase() : 'A',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 40 : 48, // ✅ REDUCED: 48/56 -> 40/48
                              color: const Color(0xFF4A90E2),
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // ✅ REDUCED: 24 -> 20
                    // ✅ NAMA - CENTERED
                    Text(
                      user.nama,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 24 : 28, // ✅ REDUCED: 28/32 -> 24/28
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // ✅ USERNAME - CENTERED
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6), // ✅ REDUCED padding
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(18), // ✅ REDUCED: 20 -> 18
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '@${user.email.split('@')[0]}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: isSmallScreen ? 14 : 16, // ✅ REDUCED: 16/18 -> 14/16
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // ✅ REDUCED: 12 -> 10
                    // ✅ EMAIL - CENTERED
                    Text(
                      user.email,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: isSmallScreen ? 12 : 14, // ✅ REDUCED: 14/16 -> 12/14
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 24), // ✅ REDUCED: 32 -> 24

                    /// ✅ Stats Card with BackdropFilter - CENTERED & SMALLER
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18), // ✅ REDUCED: 20 -> 18
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // ✅ REDUCED padding
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(18), // ✅ REDUCED: 20 -> 18
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.article_rounded,
                                color: Colors.white.withValues(alpha: 0.9),
                                size: 18, // ✅ REDUCED: 20 -> 18
                              ),
                              const SizedBox(width: 6), // ✅ REDUCED: 8 -> 6
                              Text(
                                '$postCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16, // ✅ REDUCED: 18 -> 16
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Artikel',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14, // ✅ REDUCED: 16 -> 14
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // ✅ ADDED: Bottom spacing
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTabBar(bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: const Color(0xFF4A90E2),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: const EdgeInsets.symmetric(horizontal: 16),
        labelColor: const Color(0xFF4A90E2),
        unselectedLabelColor: Colors.grey[500],
        labelStyle: TextStyle(
          fontSize: isSmallScreen ? 13 : 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: isSmallScreen ? 13 : 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.grid_view_rounded, size: isSmallScreen ? 18 : 20),
            ),
            text: "Postingan",
            height: 80,
          ),
          Tab(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.favorite_rounded, size: isSmallScreen ? 18 : 20),
            ),
            text: "Disukai",
            height: 80,
          ),
          Tab(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF4A90E2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.bookmark_rounded, size: isSmallScreen ? 18 : 20),
            ),
            text: "Disimpan",
            height: 80,
          ),
        ],
      ),
    );
  }

  Widget _buildModernArticleList(Future<List<Artikel>> future) {
    return FutureBuilder<List<Artikel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: Color(0xFF4A90E2),
                  strokeWidth: 3,
                ),
                SizedBox(height: 16),
                Text(
                  'Memuat artikel...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          return _buildErrorListState(snapshot.error.toString());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState();
        }

        final posts = snapshot.data!;
        return _buildArticleGrid(posts);
      },
    );
  }

  Widget _buildErrorListState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Terjadi Kesalahan",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4A90E2).withValues(alpha: 0.05),
                    const Color(0xFF4A90E2).withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.inbox_rounded,
                size: 56,
                color: Colors.blue[300],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Belum Ada Konten",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Konten yang kamu cari belum tersedia.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ ARTIKEL GRID - UKURAN DIPERKECIL + LIKE/COMMENT/SAVE
  Widget _buildArticleGrid(List<Artikel> posts) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // ✅ CHANGED BACK: 3 -> 2 for better interaction buttons display
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75, // ✅ ADJUSTED: 0.85 -> 0.75 for interaction buttons
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final artikel = posts[index];
        return GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ IMAGE WITH CATEGORY LABEL
                Stack(
                  children: [
                    Container(
                      height: 110, // ✅ INCREASED: 90 -> 110 for better proportion
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        image: DecorationImage(
                          image: NetworkImage('https://i1.sndcdn.com/avatars-000508491087-32hktm-t1080x1080.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // ✅ CATEGORY LABEL (TOP LEFT)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'ARTIKEL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    // ✅ BOOKMARK ICON (TOP RIGHT)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.bookmark_border_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                // ✅ CONTENT SECTION
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ TITLE
                        Expanded(
                          child: Text(
                            artikel.judul,
                            style: const TextStyle(
                              fontSize: 13, // ✅ INCREASED: 12 -> 13
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF333333),
                              height: 1.3,
                            ),
                            maxLines: 3, // ✅ INCREASED: 2 -> 3
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 6),
                        
                        // ✅ AUTHOR & DATE
                        Text(
                          'Andi', // You can replace with artikel.author if available
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(artikel.createdAt),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // ✅ INTERACTION BUTTONS ROW (LIKE, COMMENT, SAVE)
                        Row(
                          children: [
                            // LIKE BUTTON
                            GestureDetector(
                              onTap: () {
                                // Handle like action
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.favorite_border_rounded,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '0', // You can replace with actual like count
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            
                            // COMMENT BUTTON
                            GestureDetector(
                              onTap: () {
                                // Handle comment action
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '0', // You can replace with actual comment count
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            
                            // SAVE/BOOKMARK BUTTON
                            GestureDetector(
                              onTap: () {
                                // Handle save action
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  Icons.bookmark_border_rounded,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
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
      },
    );
  }
}

/// Custom SliverPersistentHeaderDelegate for Modern TabBar
class _ModernSliverTabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _ModernSliverTabDelegate(this.child);

  @override
  double get minExtent => 80;
  @override
  double get maxExtent => 80;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _ModernSliverTabDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}