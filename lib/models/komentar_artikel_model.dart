class KomentarArtikel {
  final int id;
  final int idArtikel;
  final int idSiswa;
  final int? idKomentarParent;
  final int depth;
  final String komentar;
  final DateTime dibuatPada;

  KomentarArtikel({
    required this.id,
    required this.idArtikel,
    required this.idSiswa,
    this.idKomentarParent,
    required this.depth,
    required this.komentar,
    required this.dibuatPada,
  });

  factory KomentarArtikel.fromJson(Map<String, dynamic> json) {
    return KomentarArtikel(
      id: json['id'],
      idArtikel: json['id_artikel'],
      idSiswa: json['id_siswa'],
      idKomentarParent: json['id_komentar_parent'],
      depth: json['depth'],
      komentar: json['komentar'],
      dibuatPada: DateTime.parse(json['dibuat_pada']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_artikel': idArtikel,
      'id_siswa': idSiswa,
      'id_komentar_parent': idKomentarParent,
      'depth': depth,
      'komentar': komentar,
      'dibuat_pada': dibuatPada.toIso8601String(),
    };
  }
}