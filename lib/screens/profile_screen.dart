import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/user_model.dart';
import '../models/artikel_model.dart';
import '../services/api_service.dart';
// import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
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
      backgroundColor: const Color(0xFF7ED6A8),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data?['user'] == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    snapshot.error?.toString() ?? "Gagal memuat profil",
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: _refreshProfile, child: const Text('Coba Lagi'))
                ],
              ),
            );
          }
          
          final User user = snapshot.data!['user'];
          final List<Artikel> myArticles = snapshot.data!['articles'];

          return _buildProfileView(user, myArticles);
        },
      ),
    );
  }

  Widget _buildProfileView(User user, List<Artikel> myArticles) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            backgroundColor: const Color(0xFF7ED6A8),
            foregroundColor: Colors.white,
            expandedHeight: 280.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(user, myArticles.length),
              titlePadding: const EdgeInsets.only(bottom: 50),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(icon: Icon(Icons.grid_on), text: "Postingan"),
                Tab(icon: Icon(Icons.favorite), text: "Disukai"),
                Tab(icon: Icon(Icons.bookmark), text: "Disimpan"),
              ],
            ),
          )
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildArticleList(Future.value(myArticles)),
          _buildArticleList(ApiService.fetchInteractedArticles('suka')),
          _buildArticleList(ApiService.fetchInteractedArticles('bookmark')),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(User user, int postCount) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white.withOpacity(0.3),
              child: Text(
                user.nama.isNotEmpty ? user.nama.substring(0, 1).toUpperCase() : 'S',
                style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Text(user.nama, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(user.email, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('Postingan', postCount.toString()),
                _buildStatItem('Pengikut', '0'),
                _buildStatItem('Mengikuti', '0'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleList(Future<List<Artikel>> future) {
    return FutureBuilder<List<Artikel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("Tidak ada postingan."));
        }
        final posts = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          itemBuilder: (context, index) => _buildPostCard(posts[index]),
        );
      },
    );
  }

  Widget _buildPostCard(Artikel post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (post.status == 'disetujui'
                          ? Colors.green
                          : post.status == 'ditolak'
                              ? Colors.red
                              : Colors.orange)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  post.status.toUpperCase(),
                  style: TextStyle(
                    color: post.status == 'disetujui'
                        ? Colors.green[800]
                        : post.status == 'ditolak'
                            ? Colors.red[800]
                            : Colors.orange[800],
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(_formatDate(post.createdAt), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(post.judul, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
      ],
    );
  }
}