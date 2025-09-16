class RatingArtikel {
  final int id;
  final int idArtikel;
  final int idSiswa;
  final int rating;
  final String? riwayatRating;
  final DateTime dibuatPada;

  RatingArtikel({
    required this.id,
    required this.idArtikel,
    required this.idSiswa,
    required this.rating,
    this.riwayatRating,
    required this.dibuatPada,
  });

  factory RatingArtikel.fromJson(Map<String, dynamic> json) {
    return RatingArtikel(
      id: json['id'],
      idArtikel: json['id_artikel'],
      idSiswa: json['id_siswa'],
      rating: json['rating'],
      riwayatRating: json['riwayat_rating'],
      dibuatPada: DateTime.parse(json['dibuat_pada']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_artikel': idArtikel,
      'id_siswa': idSiswa,
      'rating': rating,
      'riwayat_rating': riwayatRating,
      'dibuat_pada': dibuatPada.toIso8601String(),
    };
  }
}