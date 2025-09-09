import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, dynamic>> myPosts = [
    {
      'title': 'Review: The Psychology of Money',
      'category': 'Resensi Buku',
      'rating': 4.5,
      'comments': 23,
      'views': 456,
      'date': '1 minggu lalu',
    },
    {
      'title': 'Panduan Lengkap Menulis Artikel SEO',
      'category': 'Artikel',
      'rating': 3.5,
      'comments': 34,
      'views': 789,
      'date': '2 minggu lalu',
    },
    {
      'title': 'Tips Belajar Efektif di Era Digital',
      'category': 'Video',
      'likes': 100,
      'comments': 12,
      'views': 234,
      'date': '2 hari lalu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7ED6A8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Profil',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Profile Info
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Color(0xFF7ED6A8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Deewi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@deewi_writer',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Penulis artikel dan reviewer buku. Suka berbagi tips menulis dan membaca.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Postingan', '${myPosts.length}'),
                      _buildStatItem('Pengikut', '2.5K'),
                      _buildStatItem('Mengikuti', '186'),
                    ],
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          const Text(
                            'Postingan Saya',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur lihat semua postingan'),
                                  backgroundColor: Color(0xFF7ED6A8),
                                ),
                              );
                            },
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(
                                color: Color(0xFF7ED6A8),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: myPosts.length,
                        itemBuilder: (context, index) {
                          final post = myPosts[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
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
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7ED6A8)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    post['category'],
                                    style: const TextStyle(
                                      color: Color(0xFF2E7D32),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  post['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    // Conditional icon based on category
                                    if (post['category'] == 'Video') ...[
                                      Icon(Icons.favorite, // Changed to favorite icon for Video
                                          size: 17, color: Colors.grey), // Red color for love icon
                                      const SizedBox(width: 4),
                                      Text('${post['likes']}'), // Show likes for video
                                    ] else ...[
                                      Icon(Icons.star, // Keep star icon for other categories
                                          size: 17, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text('${post['rating']}'), // Show rating for other categories
                                    ],
                                    const SizedBox(width: 16),
                                    Icon(Icons.chat_bubble,
                                        size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text('${post['comments']}'),
                                    const SizedBox(width: 16),
                                    Icon(Icons.visibility,
                                        size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                    Text('${post['views']}'),
                                    const Spacer(),
                                    Text(
                                      post['date'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

// Settings Screen - Updated with FAQ navigation
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          const Text(
            'Akun',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            icon: Icons.person,
            title: 'Edit Profil',
            subtitle: 'Ubah informasi profil Anda',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.lock,
            title: 'Ubah Password',
            subtitle: 'Ganti password akun Anda',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Preferences Section
          const Text(
            'Preferensi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSwitchItem(
            icon: Icons.notifications,
            title: 'Notifikasi',
            subtitle: 'Terima notifikasi dari aplikasi',
            value: notificationsEnabled,
            onChanged: (value) {
              setState(() {
                notificationsEnabled = value;
              });
            },
          ),

          const SizedBox(height: 24),

          // Support Section
          const Text(
            'Bantuan & Dukungan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            icon: Icons.help,
            title: 'Pusat Bantuan',
            subtitle: 'FAQ dan panduan penggunaan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FAQScreen(),
                ),
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.feedback,
            title: 'Kirim Feedback',
            subtitle: 'Berikan masukan untuk aplikasi',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur kirim feedback'),
                  backgroundColor: Color(0xFF7ED6A8),
                ),
              );
            },
          ),
          _buildSettingsItem(
            icon: Icons.info,
            title: 'Tentang Aplikasi',
            subtitle: 'Versi 1.0.0',
            onTap: () {
              _showAboutDialog();
            },
          ),

          const SizedBox(height: 24),

          // Logout Button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showLogoutDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Keluar',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF7ED6A8).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF7ED6A8),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF7ED6A8).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF7ED6A8),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF7ED6A8),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Tentang BacainSebelas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Versi: 1.0.0'),
              SizedBox(height: 8),
              Text(
                'BacainSebelas adalah platform untuk berbagi artikel, review buku, dan tips menarik.',
                style: TextStyle(height: 1.4),
              ),
              SizedBox(height: 8),
              Text('© 2024 BacainSebelas Team'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: Color(0xFF7ED6A8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Keluar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari aplikasi?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Berhasil keluar dari aplikasi'),
                    backgroundColor: Color(0xFF7ED6A8),
                  ),
                );
              },
              child: const Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// FAQ Screen
class FAQScreen extends StatefulWidget {
  const FAQScreen({Key? key}) : super(key: key);

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final List<Map<String, dynamic>> faqData = [
    {
      'category': 'Umum',
      'questions': [
        {
          'question': 'Apa itu BacainSebelas?',
          'answer':
              'BacainSebelas adalah platform digital untuk berbagi artikel, review buku, dan tips menarik. Kami memfasilitasi komunitas penulis dan pembaca untuk saling berinteraksi dan berbagi pengetahuan.',
        },
        {
          'question': 'Bagaimana cara bergabung dengan BacainSebelas?',
          'answer':
              'Anda dapat bergabung dengan mudah melalui proses registrasi di aplikasi. Cukup masukkan email, buat password yang kuat, dan verifikasi akun Anda melalui email konfirmasi.',
        },
        {
          'question': 'Apakah BacainSebelas gratis?',
          'answer':
              'Ya, BacainSebelas gratis untuk digunakan. Anda dapat membaca, menulis, dan berinteraksi dengan konten tanpa biaya berlangganan.',
        },
      ],
    },
    {
      'category': 'Akun & Profil',
      'questions': [
        {
          'question': 'Bagaimana cara mengubah informasi profil?',
          'answer':
              'Pergi ke menu Pengaturan > Edit Profil. Di sana Anda dapat mengubah nama, username, bio, dan foto profil Anda.',
        },
        {
          'question': 'Bagaimana cara mengubah password?',
          'answer':
              'Buka menu Pengaturan > Ubah Password. Masukkan password lama, lalu password baru yang memenuhi syarat keamanan (minimal 8 karakter dengan kombinasi huruf besar, kecil, dan angka).',
        },
        {
          'question': 'Lupa password, bagaimana cara reset?',
          'answer':
              'Klik "Lupa Password?" di halaman login, masukkan email Anda, dan ikuti instruksi yang dikirim ke email untuk mereset password.',
        },
      ],
    },
    {
      'category': 'Posting & Konten',
      'questions': [
        {
          'question': 'Bagaimana cara membuat postingan baru?',
          'answer':
              'Tekan tombol "+" di beranda, pilih jenis konten (artikel, review buku, atau tips), tulis konten Anda, tambahkan kategori, dan publikasikan.',
        },
        {
          'question': 'Apakah ada batasan panjang artikel?',
          'answer':
              'Tidak ada batasan maksimal untuk panjang artikel. Namun, kami menyarankan artikel minimal 300 kata untuk memberikan nilai yang baik kepada pembaca.',
        },
        {
          'question': 'Bagaimana cara mengedit atau menghapus postingan?',
          'answer':
              'Buka profil Anda, pilih postingan yang ingin diedit, lalu tekan ikon titik tiga di pojok kanan atas untuk opsi edit atau hapus.',
        },
        {
          'question': 'Bisakah saya menjadwalkan postingan?',
          'answer':
              'Fitur penjadwalan postingan saat ini sedang dalam pengembangan dan akan segera tersedia dalam update mendatang.',
        },
      ],
    },
    {
      'category': 'Interaksi & Komunitas',
      'questions': [
        {
          'question': 'Bagaimana cara memberikan like dan komentar?',
          'answer':
              'Tekan ikon hati untuk memberikan like, dan tekan ikon komentar untuk menambahkan komentar pada postingan yang Anda baca.',
        },
        {
          'question': 'Bagaimana cara mengikuti penulis lain?',
          'answer':
              'Kunjungi profil penulis yang ingin Anda ikuti, lalu tekan tombol "Ikuti". Anda akan mendapat notifikasi ketika mereka memposting konten baru.',
        },
        {
          'question': 'Bagaimana cara melaporkan konten yang tidak pantas?',
          'answer':
              'Tekan ikon titik tiga pada postingan, pilih "Laporkan", dan pilih kategori pelanggaran. Tim moderasi akan meninjau laporan dalam 24 jam.',
        },
      ],
    },
    {
      'category': 'Masalah Teknis',
      'questions': [
        {
          'question': 'Aplikasi sering crash, bagaimana solusinya?',
          'answer':
              'Pastikan aplikasi Anda sudah versi terbaru. Jika masih bermasalah, coba restart aplikasi atau restart perangkat Anda. Jika masalah berlanjut, hubungi tim support.',
        },
        {
          'question': 'Tidak bisa login ke akun saya',
          'answer':
              'Periksa koneksi internet, pastikan email dan password benar. Jika lupa password, gunakan fitur "Lupa Password". Jika masih tidak bisa, hubungi customer service.',
        },
        {
          'question': 'Konten tidak ter-load dengan baik',
          'answer':
              'Periksa koneksi internet Anda. Jika koneksi baik, coba refresh halaman dengan menarik ke bawah. Jika masalah berlanjut, tutup dan buka kembali aplikasi.',
        },
      ],
    },
  ];

  String selectedCategory = 'Semua';

  @override
  Widget build(BuildContext context) {
    List<String> categories =
        ['Semua'] + faqData.map((e) => e['category'] as String).toList();

    List<Map<String, dynamic>> filteredQuestions = [];
    if (selectedCategory == 'Semua') {
      for (var category in faqData) {
        for (var question in category['questions']) {
          filteredQuestions.add({
            'category': category['category'],
            'question': question['question'],
            'answer': question['answer'],
          });
        }
      }
    } else {
      var categoryData =
          faqData.firstWhere((e) => e['category'] == selectedCategory);
      for (var question in categoryData['questions']) {
        filteredQuestions.add({
          'category': selectedCategory,
          'question': question['question'],
          'answer': question['answer'],
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey[600]),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur pencarian FAQ akan segera tersedia'),
                  backgroundColor: Color(0xFF7ED6A8),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF7ED6A8).withOpacity(0.1),
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.help_center,
                  size: 60,
                  color: const Color(0xFF7ED6A8),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ada yang bisa kami bantu?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Temukan jawaban untuk pertanyaan yang sering ditanyakan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.grey[100],
                    selectedColor: const Color(0xFF7ED6A8),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[700],
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),

          // FAQ List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredQuestions.length,
              itemBuilder: (context, index) {
                final faq = filteredQuestions[index];
                return FAQItem(
                  category: faq['category'],
                  question: faq['question'],
                  answer: faq['answer'],
                );
              },
            ),
          ),

          // Contact Support
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Tidak menemukan jawaban yang Anda cari?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Membuka chat dengan customer service'),
                              backgroundColor: Color(0xFF7ED6A8),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat_bubble, size: 18),
                        label: const Text('Chat Support'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7ED6A8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Mengirim email ke support@bacainsebelas.com'),
                              backgroundColor: Color(0xFF7ED6A8),
                            ),
                          );
                        },
                        icon: const Icon(Icons.email, size: 18),
                        label: const Text('Email'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF7ED6A8),
                          side: const BorderSide(color: Color(0xFF7ED6A8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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
  }
}

// FAQ Item Widget
class FAQItem extends StatefulWidget {
  final String category;
  final String question;
  final String answer;

  const FAQItem({
    Key? key,
    required this.category,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            onTap: _toggleExpansion,
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF7ED6A8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.help_outline,
                color: const Color(0xFF7ED6A8),
                size: 18,
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.category,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.question,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            trailing: AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey[600],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey[200]),
                  const SizedBox(height: 8),
                  Text(
                    widget.answer,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Apakah ini membantu?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Terima kasih atas feedback Anda!'),
                              backgroundColor: Color(0xFF7ED6A8),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.thumb_up_outlined,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Ya',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Feedback Anda membantu kami berkembang'),
                              backgroundColor: Colors.orange,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.thumb_down_outlined,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Tidak',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
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
    );
  }
}

// Edit Profile Screen
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Deewi');
  final _usernameController = TextEditingController(text: 'deewi_writer');
  final _bioController = TextEditingController(
    text:
        'Penulis artikel dan reviewer buku. Suka berbagi tips menulis dan membaca.',
  );
  final _emailController = TextEditingController(text: 'deewi@email.com');

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: const Color(0xFF7ED6A8).withOpacity(0.1),
                    child: const Icon(
                      Icons.person,
                      size: 70,
                      color: Color(0xFF7ED6A8),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF7ED6A8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Name Field
            _buildInputField(
              controller: _nameController,
              label: 'Nama Lengkap',
              icon: Icons.person,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Username Field
            _buildInputField(
              controller: _usernameController,
              label: 'Username',
              icon: Icons.alternate_email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username tidak boleh kosong';
                }
                if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                  return 'Username hanya boleh mengandung huruf, angka, dan underscore';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Email Field
            _buildInputField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Bio Field
            _buildInputField(
              controller: _bioController,
              label: 'Bio',
              icon: Icons.info,
              maxLines: 3,
              validator: (value) {
                if (value != null && value.length > 150) {
                  return 'Bio maksimal 150 karakter';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7ED6A8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF7ED6A8),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF7ED6A8),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil berhasil diperbarui'),
              backgroundColor: Color(0xFF7ED6A8),
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Terjadi kesalahan: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}

// Change Password Screen
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Ubah Password',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF7ED6A8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Color(0xFF7ED6A8), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tips Keamanan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Gunakan kombinasi huruf besar, kecil, angka, dan simbol untuk password yang kuat.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Current Password
            _buildPasswordField(
              controller: _currentPasswordController,
              label: 'Password Saat Ini',
              obscureText: _obscureCurrentPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password saat ini tidak boleh kosong';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // New Password
            _buildPasswordField(
              controller: _newPasswordController,
              label: 'Password Baru',
              obscureText: _obscureNewPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password baru tidak boleh kosong';
                }
                if (value.length < 8) {
                  return 'Password minimal 8 karakter';
                }
                if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)')
                    .hasMatch(value)) {
                  return 'Password harus mengandung huruf besar, kecil, dan angka';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Confirm Password
            _buildPasswordField(
              controller: _confirmPasswordController,
              label: 'Konfirmasi Password Baru',
              obscureText: _obscureConfirmPassword,
              onToggleVisibility: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi password tidak boleh kosong';
                }
                if (value != _newPasswordController.text) {
                  return 'Password tidak cocok';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Change Password Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7ED6A8),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Ubah Password',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Forgot Password Link
            Center(
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur lupa password'),
                      backgroundColor: Color(0xFF7ED6A8),
                    ),
                  );
                },
                child: const Text(
                  'Lupa Password?',
                  style: TextStyle(
                    color: Color(0xFF7ED6A8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock, color: Color(0xFF7ED6A8)),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: onToggleVisibility,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF7ED6A8),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                'Berhasil!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7ED6A8),
                ),
              ),
              content: const Text(
                'Password berhasil diubah. Silakan login kembali dengan password baru Anda.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Go back
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Color(0xFF7ED6A8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    }
  }
}