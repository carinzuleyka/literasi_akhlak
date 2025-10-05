import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsItem(
            icon: Icons.person_outline,
            iconColor: const Color(0xFF4A90E2),
            title: 'Edit Profil',
            subtitle: 'Ubah informasi profil Anda',
            onTap: () {
              // Navigate to edit profile
              Navigator.pushNamed(context, '/edit-profile');
            },
          ),
          const SizedBox(height: 8),
          _buildSettingsItem(
            icon: Icons.lock_outline,
            iconColor: const Color(0xFF4A90E2),
            title: 'Ubah Password',
            subtitle: 'Ganti password akun Anda',
            onTap: () {
              // Navigate to change password
              Navigator.pushNamed(context, '/change-password');
            },
          ),
          
          const SizedBox(height: 24),
          
          // Preferences Section
          const Text(
            'Preferensi',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSwitchItem(
            icon: Icons.notifications_none,
            iconColor: const Color(0xFF4A90E2),
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
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          _buildSettingsItem(
            icon: Icons.help_outline,
            iconColor: const Color(0xFF4A90E2),
            title: 'Pusat Bantuan',
            subtitle: 'FAQ dan panduan penggunaan',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Membuka pusat bantuan'),
                  backgroundColor: Color(0xFF4A90E2),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildSettingsItem(
            icon: Icons.feedback_outlined,
            iconColor: const Color(0xFF4A90E2),
            title: 'Kirim Feedback',
            subtitle: 'Berikan masukan untuk aplikasi',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur kirim feedback'),
                  backgroundColor: Color(0xFF4A90E2),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildSettingsItem(
            icon: Icons.info_outline,
            iconColor: const Color(0xFF4A90E2),
            title: 'Tentang Aplikasi',
            subtitle: 'Versi 1.0.0',
            onTap: () {
              _showAboutDialog();
            },
          ),
          
          const SizedBox(height: 32),
          
          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _showLogoutDialog();
              },
              icon: const Icon(Icons.logout, size: 20),
              label: const Text(
                'Keluar',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
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
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: 20,
          color: Colors.grey[400],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF4A90E2),
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
            'Tentang Aplikasi',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'BacainSebelas',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Versi: 1.0.0',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'BacainSebelas adalah platform untuk berbagi artikel, review buku, dan tips menarik.',
                style: TextStyle(
                  height: 1.5,
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '© 2024 BacainSebelas Team',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF4A90E2),
              ),
              child: const Text(
                'Tutup',
                style: TextStyle(
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
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari aplikasi?',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
              ),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                
                try {
                  await ApiService.logout();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal logout: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[700],
              ),
              child: const Text(
                'Keluar',
                style: TextStyle(
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