import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 3; // Set to 3 since this is the Video tab
  
  // Sample video data
  final List<Map<String, dynamic>> videos = [
    {
      'id': 'video1',
      'username': 'Michael',
      'userAvatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      'description': 'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit, Sed Do Eiusmod Tempor Incididunt Ut Labore Et Dolore Magna Aliqua. Ut Enim Ad Minim Veniam, Quis Nostrud Exercitation Ullamco Laboris Nisi Ut Aliquip Ex Ea Commodo Consequat.',
      'audioId': 'Audio00090001',
      'thumbnailUrl': 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=500&h=800&fit=crop',
      'likes': 1200,
      'comments': 89,
      'shares': 45,
      'isLiked': false,
      'isBookmarked': false,
    },
    {
      'id': 'video2',
      'username': 'Sarah Johnson',
      'userAvatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      'description': 'Review buku "Atomic Habits" yang sangat menginspirasi! Tips membangun kebiasaan baik yang bisa diterapkan sehari-hari. Sangat recommended untuk yang ingin self improvement! 📚✨',
      'audioId': 'Audio00090002',
      'thumbnailUrl': 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=500&h=800&fit=crop',
      'likes': 856,
      'comments': 124,
      'shares': 67,
      'isLiked': false,
      'isBookmarked': false,
    },
    {
      'id': 'video3',
      'username': 'Ahmad Fajar',
      'userAvatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      'description': 'Tutorial teknik smash bola voli untuk pemula! Pelajari posisi tubuh yang benar, timing yang tepat, dan cara menghasilkan pukulan yang powerful. Practice makes perfect! 🏐💪',
      'audioId': 'Audio00090003',
      'thumbnailUrl': 'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=500&h=800&fit=crop',
      'likes': 2341,
      'comments': 456,
      'shares': 123,
      'isLiked': false,
      'isBookmarked': false,
    },
  ];

  int currentVideoIndex = 0;
  PageController _pageController = PageController();

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
    _pageController.dispose();
    super.dispose();
  }

  void _toggleLike(int index) {
    setState(() {
      videos[index]['isLiked'] = !videos[index]['isLiked'];
      if (videos[index]['isLiked']) {
        videos[index]['likes']++;
      } else {
        videos[index]['likes']--;
      }
    });
  }

  void _toggleBookmark(int index) {
    setState(() {
      videos[index]['isBookmarked'] = !videos[index]['isBookmarked'];
    });
  }

  void _showCommentsModal(int index) {
    final video = videos[index];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VideoCommentsModal(
        username: video['username'],
        description: video['description'],
        comments: video['comments'],
        onAddComment: () {
          setState(() {
            videos[index]['comments']++;
          });
        },
      ),
    );
  }

  void _showShareModal(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,
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
                'Bagikan Video',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Share options would go here
            const Expanded(
              child: Center(
                child: Text('Share options coming soon...'),
              ),
            ),
          ],
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
    
    if (index == 3) {
      // Already on Video tab, do nothing
      return;
    }
    
    setState(() {
      _selectedIndex = index;
    });
    
    if (index == 0) { // Home tab
      Navigator.pop(context); // Go back to HomeScreen
    } else if (index == 4) { // Profile tab
      // TODO: Navigate to ProfileScreen
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const ProfileScreen()),
      // );
    }
    // TODO: Implement navigation for Buku tab (index == 1)
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

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: videos.length,
          onPageChanged: (index) {
            setState(() {
              currentVideoIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final video = videos[index];
            return Stack(
              children: [
                // Video background/thumbnail
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(video['thumbnailUrl']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                // Dark overlay for better text visibility
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),

                // Top status bar area
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Video',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '9:41',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Right side action buttons
                Positioned(
                  right: 16,
                  bottom: 160, // Adjusted to make room for bottom navigation
                  child: Column(
                    children: [
                      // Like button
                      GestureDetector(
                        onTap: () => _toggleLike(index),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Icon(
                                video['isLiked'] ? Icons.favorite : Icons.favorite_border,
                                color: video['isLiked'] ? Colors.red : Colors.white,
                                size: 28,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatNumber(video['likes']),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Comment button
                      GestureDetector(
                        onTap: () => _showCommentsModal(index),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.chat_bubble_outline,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatNumber(video['comments']),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Share button
                      GestureDetector(
                        onTap: () => _showShareModal(index),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.share_outlined,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatNumber(video['shares']),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom content area
                Positioned(
                  left: 16,
                  right: 80,
                  bottom: 110, // Adjusted to make room for bottom navigation
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // User info
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(video['userAvatar']),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            video['username'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Description
                      Text(
                        video['description'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Audio ID
                      Row(
                        children: [
                          const Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            video['audioId'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
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

class VideoCommentsModal extends StatefulWidget {
  final String username;
  final String description;
  final int comments;
  final VoidCallback onAddComment;

  const VideoCommentsModal({
    Key? key,
    required this.username,
    required this.description,
    required this.comments,
    required this.onAddComment,
  }) : super(key: key);

  @override
  State<VideoCommentsModal> createState() => _VideoCommentsModalState();
}

class _VideoCommentsModalState extends State<VideoCommentsModal> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _commentsList = [
    {
      'username': 'Andi Pratama',
      'comment': 'Video yang sangat informatif! Terima kasih sudah berbagi',
      'time': '2 jam',
      'likes': 12,
      'isLiked': false,
    },
    {
      'username': 'Sari Indah',
      'comment': 'Keren banget! Bisa dicoba nih tipsnya',
      'time': '1 jam',
      'likes': 8,
      'isLiked': false,
    },
    {
      'username': 'Rio Ahmad',
      'comment': 'Mantap! Ditunggu video selanjutnya',
      'time': '30 menit',
      'likes': 5,
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
            child: Text(
              '${widget.comments} Komentar',
              style: const TextStyle(
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
                        radius: 18,
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
                            Row(
                              children: [
                                Text(
                                  comment['time'],
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () => _toggleCommentLike(index),
                                  child: Row(
                                    children: [
                                      Icon(
                                        comment['isLiked'] ? Icons.favorite : Icons.favorite_border,
                                        size: 16,
                                        color: comment['isLiked'] ? Colors.red : Colors.grey[500],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        comment['likes'].toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                      hintText: 'Tambahkan komentar...',
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
                GestureDetector(
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