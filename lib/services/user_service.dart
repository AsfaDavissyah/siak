import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  String? tempApprovalMessage;    
  

  // SIMPAN DATA USER (MENERIMA UserModel)
  Future<void> saveUserData(UserModel user) async {
    return await usersRef
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
  }

  // AMBIL DATA USER BERDASARKAN UID -> UserModel
  Future<UserModel?> getUserByUid(String uid) async {
    DocumentSnapshot doc = await usersRef.doc(uid).get();

    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromMap(data);
  }

  Future<void> clearApprovalMessage(String uid) async {
    await usersRef.doc(uid).update({
      "approvalMessage": ""
    });
  }
}
