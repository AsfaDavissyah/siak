import 'package:cloud_firestore/cloud_firestore.dart';

class NilaiService {
  final CollectionReference nilaiRef = FirebaseFirestore.instance.collection(
    "nilai",
  );

  // ✅ HITUNG NILAI AKHIR
  double hitungNilaiAkhir(int tugas, int uts, int uas) {
    return (tugas * 0.3) + (uts * 0.3) + (uas * 0.4);
  }

  // ✅ KONVERSI KE PREDIKAT
  String konversiPredikat(double nilaiAkhir) {
    if (nilaiAkhir >= 85) {
      return "A";
    } else if (nilaiAkhir >= 75) {
      return "B";
    } else if (nilaiAkhir >= 65) {
      return "C";
    } else {
      return "D";
    }
  }

  // ✅ SIMPAN NILAI (SUDAH OTOMATIS)
  Future<void> tambahNilai({
    required String siswaId,
    required String siswaNama,
    required String kelas,
    required String mapel,
    required int tugas,
    required int uts,
    required int uas,
    required String guruId,
    required String guruNama,
  }) async {
    final nilaiAkhir = hitungNilaiAkhir(tugas, uts, uas);
    final predikat = konversiPredikat(nilaiAkhir);

    await nilaiRef.add({
      "siswaId": siswaId,
      "siswaNama": siswaNama,
      "kelas": kelas,
      "mapel": mapel,
      "tugas": tugas,
      "uts": uts,
      "uas": uas,
      "nilaiAkhir": nilaiAkhir,
      "predikat": predikat,
      "guruId": guruId,
      "guruNama": guruNama,
      "createdAt": Timestamp.now(),
    });
  }

  // ✅ AMBIL NILAI SISWA
  Stream<QuerySnapshot> getNilaiBySiswa(String siswaId) {
    return nilaiRef.where("siswaId", isEqualTo: siswaId).snapshots();
  }

  // ✅ Ambil semua nilai (UNTUK ADMIN)
  Stream<QuerySnapshot> getAllNilai() {
    return nilaiRef.orderBy("createdAt", descending: true).snapshots();
  }
}
