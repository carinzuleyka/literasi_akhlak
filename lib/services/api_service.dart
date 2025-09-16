import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/artikel_model.dart';
import '../models/kategori_model.dart';
import '../models/user_model.dart';

class ApiService {
  static const String _baseUrl = "http://127.0.0.1:8000/api";

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> _saveTokenAndUser(
    String token,
    Map<String, dynamic> userData,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_data', json.encode(userData));
  }

  static Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      return User.fromJson(json.decode(userDataString));
    }
    return null;
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    if (token == null) throw Exception('Sesi berakhir. Silakan login kembali.');
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  static Future<Map<String, dynamic>> signIn(
    String nisOrEmail,
    String password,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/siswa/login'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: json.encode({'login': nisOrEmail, 'password': password}),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveTokenAndUser(data['token'], data['user']);
        return {'success': true, 'user': User.fromJson(data['user'])};
      } else {
        final errorData = json.decode(response.body);
        return {
          'success': false,
          'message': errorData['message'] ?? 'Login gagal.',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Tidak dapat terhubung ke server.'};
    }
  }

  static Future<void> logout() async {
    try {
      final headers = await _getHeaders();
      await http.post(Uri.parse('$_baseUrl/siswa/logout'), headers: headers);
    } catch (e) {
      // Tidak perlu menampilkan error ke user saat logout
    } finally {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
    }
  }

  static Future<List<Artikel>> fetchTimelineArticles() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/artikel'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return (data as List).map((e) => Artikel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat timeline: ${response.body}');
    }
  }

  static Future<List<Artikel>> fetchMyArticles() async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/siswa/artikel-saya'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((e) => Artikel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat artikel saya: ${response.body}');
    }
  }

  static Future<List<Kategori>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/kategori'),
      headers: {'Accept': 'application/json'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((e) => Kategori.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat kategori: ${response.body}');
    }
  }

  static Future<void> toggleInteraction(int artikelId, String jenis) async {
    final headers = await _getHeaders();
    await http.post(
      Uri.parse('$_baseUrl/artikel/$artikelId/interaksi'),
      headers: headers,
      body: json.encode({'jenis': jenis}),
    );
  }

  static Future<void> submitRating(int artikelId, int rating) async {
    final headers = await _getHeaders();
    await http.post(
      Uri.parse('$_baseUrl/artikel/$artikelId/rating'),
      headers: headers,
      body: json.encode({'rating': rating}),
    );
  }

  static Future<List<Artikel>> fetchInteractedArticles(String jenis) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/siswa/interaksi?jenis=$jenis'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((e) => Artikel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat artikel $jenis: ${response.body}');
    }
  }

  static Future<void> submitComment(int artikelId, String komentar) async {
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('$_baseUrl/artikel/$artikelId/komentar'),
      headers: headers,
      body: json.encode({'komentar': komentar}),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan komentar: ${response.body}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchComments(int artikelId) async {
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('$_baseUrl/artikel/$artikelId/komentar'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return (data as List).map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Gagal memuat komentar: ${response.body}');
    }
  }
}