import 'dart:convert';
import 'dart:io'; // Diperlukan untuk File
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'artikel_model.dart'; // Pastikan file ini ada

// --- User Model (Tidak ada perubahan) ---
class User {
  final String nama;
  final String email;
  final String nis;
  final String kelas;

  User({
    required this.nama,
    required this.email,
    required this.nis,
    required this.kelas,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nama: json['nama'] as String? ?? 'Tanpa Nama',
      email: json['email'] as String? ?? '',
      nis: json['nis'] as String? ?? '',
      kelas: json['kelas'] as String? ?? '',
    );
  }

  String toJson() =>
      json.encode({'nama': nama, 'email': email, 'nis': nis, 'kelas': kelas});
}

// --- AuthService ---
class AuthService {
  // PENTING: Ganti dengan IP Address Anda jika menjalankan di HP/Emulator
  static const String _baseUrl = "http://127.0.0.1:8000/api";

  static String getBaseUrl() {
    return _baseUrl;
  }

  static Future<void> _saveTokenAndUser(
    String token,
    Map<String, dynamic> userData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_data', json.encode(userData));
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      return User.fromJson(json.decode(userDataString));
    }
    return null;
  }

  static Future<Map<String, dynamic>> signIn(
    String nisOrEmail,
    String password,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/siswa/login'),
            headers: {'Accept': 'application/json'},
            body: {'login': nisOrEmail, 'password': password},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveTokenAndUser(data['token'], data['user']);
        return {'success': true, 'user': User.fromJson(data['user'])};
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message':
              errorData['error'] ?? 'Login gagal. Periksa kembali data Anda.',
        };
      }
    } catch (e) {
      print('Sign In Error: $e');
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server. Periksa koneksi Anda.',
      };
    }
  }

  static Future<Map<String, dynamic>> signUp({
    required String fullName,
    required String email,
    required String password,
    required String nis,
    required String kelas,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/siswa/register'),
            headers: {'Accept': 'application/json'},
            body: {
              'nama': fullName,
              'nis': nis,
              'kelas': kelas,
              'email': email,
              'password': password,
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        await _saveTokenAndUser(data['token'], data['user']);
        return {'success': true};
      } else if (response.statusCode == 422) {
        final errors =
            json.decode(response.body)['errors'] as Map<String, dynamic>;
        final errorMessage = errors.values
            .map((e) => (e as List).join('\n'))
            .join('\n');
        return {'success': false, 'message': errorMessage};
      } else {
        return {
          'success': false,
          'message': 'Registrasi gagal (Error: ${response.statusCode})',
        };
      }
    } catch (e) {
      print('Sign Up Error: $e');
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server. Periksa koneksi Anda.',
      };
    }
  }

  static Future<void> logout() async {
    final token = await getToken();
    if (token == null) return;

    try {
      await http.post(
        Uri.parse('$_baseUrl/siswa/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      print("Error saat logout di server: $e");
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
    }
  }

  static Future<User?> getUserProfile() async {
    final token = await getToken();
    if (token == null) return null;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/siswa/me'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', json.encode(data));
        return User.fromJson(data);
      }
      return null;
    } catch (e) {
      print("Error fetching profile: $e");
      return null;
    }
  }

  static Future<List<Artikel>> getMyArticles() async {
    final token = await getToken();
    if (token == null) return [];

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/siswa/artikel'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<Artikel> artikels = body
            .map(
              (dynamic item) => Artikel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
        return artikels;
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching articles: $e");
      return [];
    }
  }

  // --- FUNGSI BARU UNTUK UPLOAD ARTIKEL ---
  static Future<Map<String, dynamic>> createArticle({
    required String title,
    required String content,
    required String jenis,
    String? idKategori,
    File? imageFile,
  }) async {
    final token = await getToken();
    if (token == null) {
      return {
        'success': false,
        'message': 'Sesi tidak valid. Silakan login kembali.',
      };
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/artikel'), // Perbaiki endpoint ke /artikel
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['judul'] = title;
      request.fields['isi'] = content;
      request.fields['jenis'] = jenis;
      if (idKategori != null) {
        request.fields['id_kategori'] = idKategori;
      }

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('gambar', imageFile.path),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);

      if (response.statusCode == 201) {
        return {'success': true, 'message': responseData['message']};
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Gagal mengunggah',
        };
      }
    } catch (e) {
      print('Create Article Error: $e');
      return {'success': false, 'message': 'Tidak dapat terhubung ke server.'};
    }
  }
}