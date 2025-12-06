class SiswaModel {
  final String? id;
  final String nis;
  final String nama;
  final String kelas;
  final String jurusan;

  SiswaModel({
    this.id,
    required this.nis,
    required this.nama,
    required this.kelas,
    required this.jurusan,
  });

  Map<String, dynamic> toMap() {
    return {
      'nis': nis,
      'nama': nama,
      'kelas': kelas,
      'jurusan': jurusan,
      'createdAt': DateTime.now(),
    };
  }

  factory SiswaModel.fromMap(String id, Map<String, dynamic> map) {
    return SiswaModel(
      id: id,
      nis: map['nis'],
      nama: map['nama'],
      kelas: map['kelas'],
      jurusan: map['jurusan'],
    );
  }
}
