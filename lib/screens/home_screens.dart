import 'package:flutter/material.dart';
import 'notification_screen.dart';
import 'profile_screen.dart'; 
import 'video_screen.dart';

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
            'Smash adalah salah satu teknik serangan paling mematikan dalam bola voli. Untuk menghasilkan smash yang efektif, seorang pemain harus menguasai tiga aspek penting: lompatan yang presisi, ayunan tangan yang kuat, dan penempatan bola yang akurat.Lompatan harus dilakukan tepat waktu saat bola berada di posisi ideal. Kemudian, ayunan tangan dilakukan dengan kecepatan tinggi dari belakang ke depan, sambil mempertahankan pergelangan tangan yang fleksibel agar bola dapat dipukul tajam ke arah lapangan lawan. Selain kekuatan, pemain juga perlu cerdas dalam menentukan arah smash, misalnya menyasar area kosong atau titik lemah pertahanan lawan.Teknik smash yang baik bukan hanya soal tenaga, tapi juga kombinasi dari ketepatan, strategi, dan koordinasi tim. Tanpa itu, smash tidak akan menghasilkan poin. Oleh karena itu, latihan rutin dan pemahaman taktik sangat diperlukan untuk menciptakan smash yang tak terbendung.',
        'likes': 245,
        'comments': 42,
        'readTime': '5 min',
        'isLiked': false,
      },
      {
        'type': 'article',
        'username': 'Sarah',
        'title': 'Review buku: ATOMIC HABITS',
        'imageUrl':
            'https://assets.telkomsel.com/public/2024-10/buku%20atomic%20habits.png',
        'rating': 4.5,
        'time': '4 jam lalu',
        'description':
            'Atomic Habits karya James Clear menjelaskan cara membentuk kebiasaan baik melalui perubahan kecil namun konsisten. Buku ini mengajarkan bahwa perubahan besar berasal dari tindakan sederhana yang dilakukan berulang, bukan dari motivasi sesaat. Konsep seperti "habit stacking" dan “sistem identitas” membuat kita lebih mudah membangun rutinitas positif.Dengan gaya bahasa yang mudah dipahami dan contoh yang relevan, buku ini cocok bagi siapa saja yang ingin jadi lebih produktif, mengubah kebiasaan buruk, atau memperbaiki kualitas hidup. Atomic Habits bukan hanya teori, tapi panduan praktis yang bisa langsung diterapkan dalam kehidupan sehari-hari.',
        'likes': 89,
        'comments': 23,
        'readTime': '5 min',
        'isLiked': false,
      },
    ],
    'Artikel': [
      {
        'type': 'article',
        'username': 'Vivian',
        'title': 'AI Revolution: Dampak ChatGPT terhadap Dunia Kerja',
        'imageUrl':
            'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=500&h=300&fit=crop',
        'rating': 4.7,
        'time': '6 jam lalu',
        'description':
            'Artificial Intelligence (AI) makin berkembang pesat dan memberi dampak besar di dunia kerja. Banyak pekerjaan manual seperti input data, layanan pelanggan, hingga analisis laporan kini bisa dilakukan oleh mesin dengan cepat dan efisien. Ini membuat perusahaan bisa menghemat biaya dan waktu, tapi di sisi lain menimbulkan kekhawatiran soal pengurangan tenaga kerja manusia.Meski begitu, AI juga menciptakan peluang baru, seperti profesi data analyst, AI developer, hingga AI ethicist. Intinya, dunia kerja sedang bertransformasi, dan manusia harus beradaptasi. Mengasah skill digital, berpikir kritis, dan memahami teknologi menjadi hal penting agar kita tetap relevan di era AI ini.',
        'likes': 456,
        'comments': 128,
        'readTime': '12 min',
        'isLiked': false,
      },
    ],
    'Resensi Buku': [
      {
        'type': 'article',
        'username': 'Ahmad Fadil',
        'title': 'Review: "Akhlak Mulia" - Panduan Membangun Karakter Islami',
        'imageUrl':
            'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=500&h=300&fit=crop',
        'rating': 4.9,
        'time': '9 jam lalu',
        'description':
            'Buku Akhlak Mulia memberikan panduan sederhana namun menyentuh tentang bagaimana membangun karakter Islami yang kuat. Ditulis berdasarkan Al-Qur’an dan sunnah, buku ini mengulas berbagai nilai seperti jujur, sabar, ikhlas, rendah hati, dan pemaaf—semuanya penting dalam kehidupan sehari-hari.Penjelasannya tidak menggurui, justru penuh ajakan refleksi dan contoh nyata. Buku ini cocok untuk siapa saja yang ingin memperbaiki diri dan meningkatkan kualitas hubungan dengan Allah dan sesama manusia. Sangat direkomendasikan bagi remaja dan dewasa yang ingin memperkuat kepribadian dengan nilai-nilai Islam.',
        'likes': 456,
        'comments': 128,
        'readTime': '8 min',
        'isLiked': false,
      },
    ],
    'Resensi Film': [
      {
        'type': 'article',
        'username': 'Michael',
        'title': 'Review Film "Dune: Part Two" - Epik Sci-Fi yang Memukau',
        'imageUrl':
            'https://images.unsplash.com/photo-1489599511024-2d9b2b97c3ab?w=500&h=300&fit=crop',
        'rating': 4.6,
        'time': '2 hari lalu',
        'description':
            'Dune: Part Two melanjutkan kisah Paul Atreides di planet gurun Arrakis. Film ini menawarkan perpaduan sempurna antara konflik politik, perjuangan spiritual, dan visual yang sangat memukau. Sutradara Denis Villeneuve berhasil memperdalam cerita dengan lebih emosional dan intens dibanding bagian pertamanya.Karakter-karakter seperti Chani, Stilgar, dan Feyd-Rautha mendapat porsi yang lebih besar, membuat ceritanya lebih hidup. Dari sinematografi hingga scoring, semuanya terasa megah. Dune: Part Two bukan cuma tontonan, tapi pengalaman sinematik yang mendalam dan wajib ditonton bagi pencinta sci-fi dan drama epik..',
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
        'time': '3 hari lalu',
        'description':
            'Oppenheimer adalah film biografi karya Christopher Nolan yang menggambarkan kehidupan J. Robert Oppenheimer, ilmuwan di balik proyek bom atom. Film ini menyajikan alur cerita yang kompleks, penuh dialog intelektual, dan dilema moral tentang kekuatan sains dan tanggung jawab manusia.Cillian Murphy tampil luar biasa sebagai Oppenheimer, menunjukkan sisi jenius sekaligus gelap dari tokoh tersebut. Visual khas Nolan, skoring musik yang menegangkan, dan penggambaran era Perang Dunia membuat film ini terasa sangat kuat. Oppenheimer bukan film aksi biasa, tapi film berpikir yang mengajak kita merenung tentang konsekuensi dari kemajuan ilmu pengetahuan.',
        'likes': 234,
        'comments': 89,
        'readTime': '9 min',
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

  void _navigateToDetail(int index) {
    final article = filteredArticles[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailScreen(
          username: article['username'],
          time: article['time'],
          title: article['title'] ?? '',
          imageUrl: article['imageUrl'],
          rating: article['rating']?.toDouble(),
          description: article['description'] ?? article['content'],
          likes: article['likes'],
          comments: article['comments'],
          readTime: article['readTime'],
          isTextOnly: article['type'] == 'text',
        ),
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
      _showCreatePostDialog();
      return;
    }
    
    setState(() {
      _selectedIndex = index;
    });
    
    if (index == 3) {
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
                              onPressed: () {},
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
                              onPressed: () {},
                              icon: const Icon(Icons.grid_view),
                            ),
                            IconButton(
                              onPressed: () {},
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
                            onLike: () => _toggleLike(articleIndex),
                            onComment: () => _showCommentsModal(articleIndex),
                            onTap: () => _navigateToDetail(articleIndex),
                          );
                        } else {
                          return ArticleTextCard(
                            username: article['username'],
                            time: article['time'],
                            content: article['content'],
                            likes: article['likes'],
                            comments: article['comments'],
                            isLiked: article['isLiked'],
                            onLike: () => _toggleLike(articleIndex),
                            onComment: () => _showCommentsModal(articleIndex),
                            onTap: () => _navigateToDetail(articleIndex),
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
      'comment': 'Artikel yang sangat informatif! Terima kasih sudah berbagi.',
      'time': '2 jam',
      'likes': 2,
      'isLiked': false,
    },
    {
      'username': 'Akmal Zains',
      'comment': 'Penjelasannya sangat detail dan mudah dipahami.',
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
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
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
                      const CircleAvatar(
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
                const CircleAvatar(
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

class ArticleDetailScreen extends StatefulWidget {
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
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool isLiked = false;
  late int likesCount;
  late int commentsCount;

  @override
  void initState() {
    super.initState();
    likesCount = widget.likes;
    commentsCount = widget.comments;
  }

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
      if (isLiked) {
        likesCount++;
      } else {
        likesCount--;
      }
    });
  }

  void _showCommentsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentsModal(
        username: widget.username,
        title: widget.title,
        comments: commentsCount,
        onAddComment: () {
          setState(() {
            commentsCount++;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.isTextOnly ? 'Detail Post' : 'Detail Artikel'),
        backgroundColor: const Color(0xFF4A90E2),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: () {
              // TODO: Implement bookmark functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!widget.isTextOnly && widget.imageUrl != null)
              Container(
                height: 250,
                width: double.infinity,
                child: Stack(
                  children: [
                    Image.network(
                      widget.imageUrl!,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 250,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                    if (widget.readTime != null)
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            widget.readTime!,
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
              ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
                        ),
                        radius: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              widget.time,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!widget.isTextOnly && widget.rating != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 18),
                              const SizedBox(width: 4),
                              Text(
                                widget.rating.toString(),
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
                  const SizedBox(height: 20),
                  if (!widget.isTextOnly && widget.title.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  Text(
                    widget.description,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[200]!),
                        bottom: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildActionButton(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          likesCount.toString(),
                          isLiked ? Colors.red : Colors.grey[600]!,
                          _toggleLike,
                        ),
                        const SizedBox(width: 32),
                        _buildActionButton(
                          Icons.chat_bubble_outline,
                          commentsCount.toString(),
                          Colors.grey[600]!,
                          _showCommentsModal,
                        ),
                        const SizedBox(width: 32),
                        _buildActionButton(
                          Icons.share_outlined,
                          'Bagikan',
                          Colors.grey[600]!,
                          () {
                            // TODO: Implement share functionality
                          },
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            // TODO: Implement bookmark functionality
                          },
                          icon: const Icon(Icons.bookmark_border),
                          color: Colors.grey[600],
                          iconSize: 24,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
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
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onTap;

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
    required this.isLiked,
    required this.onLike,
    required this.onComment,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
                      const CircleAvatar(
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                        onPressed: () {},
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
      ),
    );
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
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onTap;

  const ArticleTextCard({
    Key? key,
    required this.username,
    required this.time,
    required this.content,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.onLike,
    required this.onComment,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
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
                const CircleAvatar(
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
                  onPressed: () {},
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
                  onPressed: () {},
                  icon: const Icon(Icons.bookmark_border),
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),
      ),
    );
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