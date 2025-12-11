import 'package:cloud_firestore/cloud_firestore.dart';

class GuruService {
  final CollectionReference guruRef =
      FirebaseFirestore.instance.collection('guru');

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  // ✅ TAMBAH GURU + KAITKAN KE USERS
  Future<void> tambahGuru({
    required String uid,
    required String nip,
    required String nama,
    required String mapel,
  }) async {
    final doc = await guruRef.add({
      "uid": uid,
      "nip": nip,
      "nama": nama,
      "mapel": mapel,
    });

    // update linkedId di users
    await usersRef.doc(uid).update({
      "linkedId": doc.id,
    });
  }

  Future<void> accGuru({
  required String uid,
  required String nama,
  required String nip,
  required String mapel,
}) async {
  // 1. Tambah data guru
  final doc = await guruRef.add({
    "uid": uid,
    "nip": nip,
    "nama": nama,
    "mapel": mapel,
  });

  // 2. Update user jadi approved
  await usersRef.doc(uid).update({
    "linkedId": doc.id,
    "isApproved": true,
  });
}


  // ✅ AMBIL SEMUA DATA GURU
  Stream<QuerySnapshot> getAllGuru() {
    return guruRef.snapshots();
  }

  // ✅ UPDATE DATA GURU
  Future<void> updateGuru(String id, Map<String, dynamic> data) async {
    await guruRef.doc(id).update(data);
  }

  // ✅ HAPUS GURU
  Future<void> deleteGuru(String id, String uid) async {
    await guruRef.doc(id).delete();
    await usersRef.doc(uid).update({"linkedId": ""});
  }
}
