import 'package:cloud_firestore/cloud_firestore.dart';

class PengumumanService {
  final CollectionReference pengumumanRef = FirebaseFirestore.instance
      .collection("pengumuman");

  // ✅ TAMBAH PENGUMUMAN (ADMIN)
  Future<void> tambahPengumuman({
    required String judul,
    required String isi,
    required String tujuan, // guru | siswa | semua
    required String adminId,
  }) async {
    await pengumumanRef.add({
      "judul": judul,
      "isi": isi,
      "tujuan": tujuan,
      "adminId": adminId,
      "createdAt": Timestamp.now(),
    });
  }

  Stream<List<QueryDocumentSnapshot>> getPengumumanByRoleGabungan(String role) async* {
  final pengumumanRef = FirebaseFirestore.instance.collection("pengumuman");

  final khususStream = pengumumanRef
      .where("tujuan", isEqualTo: role)
      .snapshots();

  final semuaStream = pengumumanRef
      .where("tujuan", isEqualTo: "semua")
      .snapshots();

  await for (final khususSnapshot in khususStream) {
    final semuaSnapshot = await semuaStream.first;

    final gabungan = [
      ...khususSnapshot.docs,
      ...semuaSnapshot.docs,
    ];

    yield gabungan;
  }
}



  // ✅ AMBIL SEMUA (ADMIN)
  Stream<QuerySnapshot> getAllPengumuman() {
    return pengumumanRef.orderBy("createdAt", descending: true).snapshots();
  }

  // ✅ HAPUS (ADMIN)
  Future<void> hapusPengumuman(String id) async {
    await pengumumanRef.doc(id).delete();
  }
}
