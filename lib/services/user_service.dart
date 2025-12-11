import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  // Menyimpan pesan persetujuan setelah login (optional)
  String? tempApprovalMessage;

  // SIMPAN / UPDATE DATA USER
  Future<void> saveUserData(UserModel user) async {
    await usersRef.doc(user.uid).set(
      user.toMap(),
      SetOptions(merge: true), // agar tidak menghapus field lain
    );
  }

  // AMBIL USER BY UID
  Future<UserModel?> getUserByUid(String uid) async {
    DocumentSnapshot doc = await usersRef.doc(uid).get();

    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  // HAPUS PESAN APPROVAL SETELAH USER MELIHAT SEKALI
  Future<void> clearApprovalMessage(String uid) async {
    await usersRef.doc(uid).update({
      "approvalMessage": "",
    });
  }
}
