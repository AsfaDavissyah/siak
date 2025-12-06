import 'package:cloud_firestore/cloud_firestore.dart';

class SiswaService {
  final CollectionReference siswaRef =
      FirebaseFirestore.instance.collection('siswa');

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  // ✅ TAMBAH DATA SISWA + KAITKAN KE USERS
  Future<void> tambahSiswa({
    required String uid,
    required String nis,
    required String nama,
    required String kelas,
    required String jurusan,
  }) async {
    // 1. Tambah ke collection siswa
    final doc = await siswaRef.add({
      "uid": uid,
      "nis": nis,
      "nama": nama,
      "kelas": kelas,
      "jurusan": jurusan,
    });

    // 2. Update linkedId di users
    await usersRef.doc(uid).update({
      "linkedId": doc.id,
    });
  }

  // ✅ AMBIL SEMUA DATA SISWA
  Stream<QuerySnapshot> getAllSiswa() {
    return siswaRef.snapshots();
  }

  // ✅ UPDATE DATA SISWA
  Future<void> updateSiswa(String id, Map<String, dynamic> data) async {
    await siswaRef.doc(id).update(data);
  }

  // ✅ HAPUS SISWA
  Future<void> deleteSiswa(String id, String uid) async {
    await siswaRef.doc(id).delete();
    await usersRef.doc(uid).update({"linkedId": ""});
  }
}
