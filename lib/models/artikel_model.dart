class Penulis {
  final int id;
  final String nama;
  Penulis({required this.id, required this.nama});

  factory Penulis.fromJson(Map<String, dynamic> json) {
    return Penulis(id: json['id'] ?? 0, nama: json['nama'] ?? 'Anonim');
  }
}

class Artikel {
  final int id;
  final String judul;
  final String? isi;
  final String status;
  int jumlahDilihat;
  int jumlahSuka;
  final String createdAt;
  final String? kategoriNama;
  final String? gambarUrl;
  final Penulis penulis;
  double? rating; // Rating rata-rata (opsional dari API)
  double? userRating; // Rating dari user saat ini
  List<Map<String, dynamic>>? komentar; // Daftar komentar (opsional dari API)

  // Properti untuk state di UI
  bool isLiked;
  bool isBookmarked;

  Artikel({
    required this.id,
    required this.judul,
    this.isi,
    required this.status,
    required this.jumlahDilihat,
    required this.jumlahSuka,
    required this.createdAt,
    this.kategoriNama,
    this.gambarUrl,
    required this.penulis,
    this.rating,
    this.userRating,
    this.komentar,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      id: json['id'],
      judul: json['judul'] ?? 'Tanpa Judul',
      isi: json['isi'],
      status: json['status'] ?? 'menunggu',
      jumlahDilihat: json['jumlah_dilihat'] ?? 0,
      jumlahSuka: json['jumlah_suka'] ?? 0,
      createdAt: json['created_at'] ?? '',
      kategoriNama: json['kategori'] != null ? json['kategori']['nama'] : 'Tanpa Kategori',
      gambarUrl: json['gambar_url'],
      penulis: Penulis.fromJson(json['siswa'] ?? {}),
      rating: (json['rating'] as num?)?.toDouble(), // Rating rata-rata
      userRating: (json['user_rating'] as num?)?.toDouble(), // Rating user
      komentar: json['komentar'] != null
          ? (json['komentar'] as List).map((e) => e as Map<String, dynamic>).toList()
          : null,
      isLiked: json['is_liked'] ?? false,
      isBookmarked: json['is_bookmarked'] ?? false,
    );
  }
}