import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}


class _VideoScreenState extends State<VideoScreen> {
  // Data dummy untuk video, nantinya bisa diganti dengan data dari API
  final List<Map<String, dynamic>> _videos = [
    {
      'username': 'Mochamad Akmal Zains',
      'userAvatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      'description': 'Resensi film Interstellar (2014) - Sebuah mahakarya fiksi ilmiah tentang cinta, waktu, dan harapan umat manusia.',
      'audioId': 'Original Audio - akmalzains08',
      'thumbnailUrl': 'https://images.unsplash.com/photo-1611532736597-de2d4265fba3?w=500&h=800&fit=crop',
      'likes': 1250,
      'comments': 92,
      'shares': 45,
      'isLiked': false,
    },
    {
      'username': 'Siswa Kreatif',
      'userAvatar': 'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
      'description': 'Membahas buku biografi I Gusti Ngurah Rai. Semangat kepahlawanannya luar biasa!',
      'audioId': 'Audio Populer - Suara Inspirasi',
      'thumbnailUrl': 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=500&h=800&fit=crop',
      'likes': 856,
      'comments': 124,
      'shares': 67,
      'isLiked': true,
    },
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

  }

  @override
  void dispose() {

    _pageController.dispose();
    super.dispose();
  }

  // Fungsi untuk format angka (1200 -> 1.2k)
  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  void _toggleLike(int index) {
    setState(() {
      _videos[index]['isLiked'] = !_videos[index]['isLiked'];
      _videos[index]['isLiked'] ? _videos[index]['likes']++ : _videos[index]['likes']--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return Stack(
            fit: StackFit.expand,
            children: [
              // Latar belakang video (gambar thumbnail)
              Image.network(
                video['thumbnailUrl'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  const Center(child: Icon(Icons.error, color: Colors.white)),
              ),
              // Gradient agar teks terbaca
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              // Konten UI di atas video
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildVideoInfo(video), // Info video di kiri
                        const Spacer(),
                        _buildActionButtons(video, index), // Tombol aksi di kanan
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Widget untuk info video (kiri bawah)
  Widget _buildVideoInfo(Map<String, dynamic> video) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(video['userAvatar']),
              ),
              const SizedBox(width: 8),
              Text(
                video['username'],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            video['description'],
            style: const TextStyle(color: Colors.white, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.music_note, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                video['audioId'],
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk tombol aksi (kanan)
  Widget _buildActionButtons(Map<String, dynamic> video, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          icon: video['isLiked'] ? Icons.favorite : Icons.favorite_border,
          label: _formatNumber(video['likes']),
          color: video['isLiked'] ? Colors.red : Colors.white,
          onTap: () => _toggleLike(index),
        ),
        const SizedBox(height: 20),
        _buildActionButton(
          icon: Icons.comment_rounded,
          label: _formatNumber(video['comments']),
          onTap: () { /* TODO: Buka modal komentar */ },
        ),
        const SizedBox(height: 20),
        _buildActionButton(
          icon: Icons.bookmark,
          label: "Simpan",
          onTap: () { /* TODO: Logika bookmark */ },
        ),
        const SizedBox(height: 20),
        _buildActionButton(
          icon: Icons.share,
          label: _formatNumber(video['shares']),
          onTap: () { /* TODO: Logika share */ },

        ),
      ],
    );
  }

  // Widget untuk satu tombol aksi
  Widget _buildActionButton({required IconData icon, required String label, VoidCallback? onTap, Color color = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}