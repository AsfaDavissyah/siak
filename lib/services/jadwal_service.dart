import 'package:cloud_firestore/cloud_firestore.dart';

class JadwalService {
  final CollectionReference jadwalRef = FirebaseFirestore.instance.collection(
    'jadwal',
  );

  // ✅ Tambah Jadwal
  Future<void> tambahJadwal({
    required String guruId,
    required String guruNama,
    required String mapel,
    required String kelas,
    required String hari,
    required String jam,
  }) async {
    await jadwalRef.add({
      "guruId": guruId,
      "guruNama": guruNama,
      "mapel": mapel,
      "kelas": kelas,
      "hari": hari,
      "jam": jam,
    });
  }

  // ✅ Ambil semua jadwal (Admin)
  Stream<QuerySnapshot> getAllJadwal() {
    return jadwalRef.snapshots();
  }

  // ✅ Jadwal khusus guru
  Stream<QuerySnapshot> getJadwalByGuru(String guruId) {
    return jadwalRef.where('guruId', isEqualTo: guruId).snapshots();
  }

  // ✅ Jadwal khusus kelas (Siswa)
  Stream<QuerySnapshot> getJadwalByKelas(String kelas) {
    return jadwalRef.where("kelas", isEqualTo: kelas).snapshots();
  }

  // ✅ Update Jadwal
  Future<void> updateJadwal(String id, Map<String, dynamic> data) async {
    await jadwalRef.doc(id).update(data);
  }

  // ✅ Hapus Jadwal
  Future<void> deleteJadwal(String id) async {
    await jadwalRef.doc(id).delete();
  }
}
