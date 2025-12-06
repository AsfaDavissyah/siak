import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserService {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  // SIMPAN DATA USER SETELAH REGISTER
  Future<void> saveUserData(UserModel user) async {
    return await usersRef.doc(user.uid).set(user.toMap());
  }

  // AMBIL DATA USER BERDASARKAN UID
  Future<UserModel?> getUserByUid(String uid) async {
    DocumentSnapshot doc = await usersRef.doc(uid).get();

    if (!doc.exists) return null;

    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }
}
