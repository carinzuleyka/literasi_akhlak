import 'dart:convert';

class User {
  final int id;
  final String nama;
  final String email;
  final String nis;
  final String kelas;

  User({
    required this.id,
    required this.nama,
    required this.email,
    required this.nis,
    required this.kelas,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      nama: json['nama'] as String? ?? 'Tanpa Nama',
      email: json['email'] as String? ?? '',
      nis: json['nis'] as String? ?? '',
      kelas: json['kelas'] as String? ?? '',
    );
  }

  String toJson() => json.encode({
        'id': id,
        'nama': nama,
        'email': email,
        'nis': nis,
        'kelas': kelas,
      });
} 