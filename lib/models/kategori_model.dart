// models/kategori_model.dart

class Kategori {
  final int id;
  final String nama;
  final String? deskripsi;
  final int jumlahArtikel;

  Kategori({
    required this.id,
    required this.nama,
    this.deskripsi,
    required this.jumlahArtikel,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      nama: json['nama'] ?? 'Tanpa Nama',
      deskripsi: json['deskripsi'],
      jumlahArtikel: json['artikel_count'] ?? 0,
    );
  }
}