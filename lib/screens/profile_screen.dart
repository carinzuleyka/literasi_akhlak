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
      return DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFE),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF4A90E2),
                    Color(0xFF6BA3E8),
                  ],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              ),
            );
          }
          
          if (snapshot.hasError || !snapshot.hasData || snapshot.data?['user'] == null) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF4A90E2),
                    Color(0xFF6BA3E8),
                  ],
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        snapshot.error?.toString() ?? "Gagal memuat profil",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF4A90E2),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Coba Lagi',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          
          final User user = snapshot.data!['user'] as User;
          final List<Artikel> myArticles = snapshot.data!['articles'] as List<Artikel>;

          return _buildProfileView(user, myArticles);
        },
      ),
    );
  }

  Widget _buildProfileView(User user, List<Artikel> myArticles) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final headerHeight = isSmallScreen ? 240.0 : 280.0; // Further reduced height
        
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
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildProfileHeader(user, myArticles.length, isSmallScreen),
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: const Color(0xFF4A90E2),
                      indicatorWeight: 3,
                      indicatorPadding: const EdgeInsets.symmetric(horizontal: 20),
                      labelColor: const Color(0xFF4A90E2),
                      unselectedLabelColor: Colors.grey[600],
                      labelStyle: TextStyle(
                        fontSize: isSmallScreen ? 13 : 15,
                        fontWeight: FontWeight.w700,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontSize: isSmallScreen ? 13 : 15,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: [
                        Tab(
                          icon: Icon(Icons.grid_view_rounded, size: isSmallScreen ? 20 : 22),
                          text: "Postingan",
                          height: 65,
                        ),
                        Tab(
                          icon: Icon(Icons.favorite_rounded, size: isSmallScreen ? 20 : 22),
                          text: "Disukai",
                          height: 65,
                        ),
                        Tab(
                          icon: Icon(Icons.bookmark_rounded, size: isSmallScreen ? 20 : 22),
                          text: "Disimpan",
                          height: 65,
                        ),
                      ],
                    ),
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: Container(
            color: const Color(0xFFF8FAFE),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildArticleList(Future.value(myArticles)),
                _buildArticleList(ApiService.fetchInteractedArticles('suka')),
                _buildArticleList(ApiService.fetchInteractedArticles('bookmark')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(User user, int postCount, bool isSmallScreen) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A90E2),
            Color(0xFF6BA3E8),
            Color(0xFF5B9CE6),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20.0 : 32.0,
            vertical: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: isSmallScreen ? 20 : 32),
              // Profile Picture with shadow
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: CircleAvatar(
                  radius: isSmallScreen ? 50 : 60,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        user.nama.isNotEmpty ? user.nama.substring(0, 1).toUpperCase() : 'A',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 38 : 48,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              // User name with better typography
              Flexible(
                child: Text(
                  user.nama,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 24 : 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              const SizedBox(height: 12),
              // Username display
              Text(
                '@${user.email.split('@')[0]}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // User email with better styling
              Text(
                user.email,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: isSmallScreen ? 20 : 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, bool isSmallScreen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isSmallScreen ? 20 : 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: isSmallScreen ? 12 : 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildArticleList(Future<List<Artikel>> future) {
    return FutureBuilder<List<Artikel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF4A90E2),
              strokeWidth: 2.5,
            ),
          );
        }
        
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.error_outline_rounded,
                      size: 48,
                      color: Colors.red[400],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Terjadi kesalahan",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Error: ${snapshot.error}",
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
        
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.article_rounded,
                      size: 56,
                      color: const Color(0xFF4A90E2).withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Tidak ada postingan",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Mulai berbagi artikel menarik",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        
        final posts = snapshot.data!;
        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 800 ? 2 : 1;
            
            if (crossAxisCount == 2) {
              return GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: posts.length,
                itemBuilder: (context, index) => _buildPostCard(posts[index]),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: posts.length,
              itemBuilder: (context, index) => _buildPostCard(posts[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildPostCard(Artikel post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Handle post tap
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status and Date Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _getStatusColor(post.status).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getStatusColor(post.status).withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          post.status.toUpperCase(),
                          style: TextStyle(
                            color: _getStatusColor(post.status),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                _formatDate(post.createdAt),
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Post Title
                Text(
                  post.judul,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    height: 1.4,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'disetujui':
        return const Color(0xFF10B981);
      case 'ditolak':
        return const Color(0xFFEF4444);
      case 'menunggu':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }
}

// Custom delegate for pinned tab bar
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Widget _tabBar;

  @override
  double get minExtent => 65.0;

  @override
  double get maxExtent => 65.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}