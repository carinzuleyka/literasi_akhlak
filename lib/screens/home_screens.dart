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

class _HomeScreenState extends State<HomeScreen> {
  User? _user;
  late Future<List<Artikel>> _timelineFuture;
  late Future<List<Kategori>> _kategoriFuture;
  String _selectedCategory = 'Semua';
  int _selectedIndex = 0;

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
    _loadInitialData();
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

  @override
  Widget build(BuildContext context) {
    final String greetingName = _user?.nama.split(' ').first ?? 'Siswa';

    return Scaffold(
      backgroundColor: const Color(0xFF7ED6A8),
      body: _selectedIndex == 0
          ? SafeArea(
              child: Column(
                children: [
                  _buildHeader(greetingName),
                  _buildCategoryFilters(),
                  _buildArticleTimeline(),
                ],
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

  Widget _buildHeader(String greetingName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Selamat Pagi, $greetingName 🌟',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Cari Artikel',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
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

          final allCategories = [Kategori(id: 0, nama: 'Semua', jumlahArtikel: 0, deskripsi: null), ...snapshot.data!];

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allCategories.length,
            itemBuilder: (context, index) {
              final category = allCategories[index];
              final isSelected = _selectedCategory == category.nama;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(category.nama),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = category.nama;
                      // TODO: Implement filter logic
                    });
                  },
                  backgroundColor: Colors.white.withOpacity(0.3),
                  selectedColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  checkmarkColor: const Color(0xFF2E7D32),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildArticleTimeline() {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshTimeline,
          child: FutureBuilder<List<Artikel>>(
            future: _timelineFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Belum ada artikel untuk ditampilkan.'));
              }

              final artikels = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: artikels.length,
                itemBuilder: (context, index) {
                  return _buildContentCard(artikels[index]);
                },
              );
            },
          ),
        ),
      ),
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
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF7ED6A8).withOpacity(0.2),
                  child: Text(
                    item.penulis.nama.isNotEmpty ? item.penulis.nama.substring(0, 1) : 'A',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.penulis.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(_formatDate(item.createdAt), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (item.gambarUrl != null && item.gambarUrl!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.gambarUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(child: Text('Gambar tidak tersedia')),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            Text(item.judul, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(item.kategoriNama ?? 'Tanpa Kategori', style: const TextStyle(color: Color(0xFF7ED6A8), fontWeight: FontWeight.w500)),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(item.isLiked ? Icons.favorite : Icons.favorite_border, color: item.isLiked ? Colors.red : Colors.grey),
                      onPressed: () => _handleLike(item),
                    ),
                    const SizedBox(width: 4),
                    Text('${item.jumlahSuka}'),
                    const SizedBox(width: 16),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                      onPressed: () { /* Buka halaman komentar */ },
                    ),
                  ],
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(item.isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: item.isBookmarked ? const Color(0xFF7ED6A8) : Colors.grey),
                  onPressed: () => _handleBookmark(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}