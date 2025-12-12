import 'auth_service.dart';
import 'user_service.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final AuthService authService = AuthService();
  final UserService userService = UserService();

  static const String adminEmail = "admin@sisakademik.com";

  // REGISTER
  Future<void> registerAccount({
    required String email,
    required String password,
    required String name,
    required String username,
    required String role,
    required String linkedId,
    required bool isApproved,
    String kelas = '',
  }) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      throw Exception("Email, password, dan username wajib diisi.");
    }

    if (email.toLowerCase() == adminEmail) {
      throw Exception(
        "Akun admin tidak boleh didaftarkan dari halaman register.",
      );
    }

    if (role.toLowerCase() == "admin") {
      throw Exception("Role admin hanya boleh dibuat oleh sistem.");
    }

    const allowedRoles = ["guru", "siswa"];
    if (!allowedRoles.contains(role.toLowerCase())) {
      throw Exception(
        "Role tidak valid. Hanya guru atau siswa yang diperbolehkan.",
      );
    }

    // register ke Firebase Auth
    final userCredential = await authService.registerUser(
      email: email,
      password: password,
    );

    if (userCredential == null) {
      throw Exception("Gagal membuat akun.");
    }

    final uid = userCredential.uid;

    final userModel = UserModel(
      uid: uid,
      name: name,
      username: username,
      role: role.toLowerCase(),
      linkedId: linkedId,
      kelas: kelas,
      email: email,
      isApproved: false,
    );

    await userService.saveUserData(userModel);
  }

  // LOGIN
  Future<UserModel?> loginAccount({
    required String email,
    required String password,
  }) async {
    final user = await authService.loginUser(email: email, password: password);

    if (user == null) {
      throw Exception("Login gagal.");
    }

    final userData = await userService.getUserByUid(user.uid);

    if (userData == null) {
      throw Exception("Data user tidak ditemukan di Firestore.");
    }

    // jika ingin mencegah login sebelum isApproved:
    // 🔥 ADMIN Selalu diizinkan masuk
    if (userData.role != "admin" &&
        (userData.isApproved == false || userData.isApproved == null)) {
      throw Exception("Akun Anda sedang diproses oleh admin.");
    }

    // Jika ada pesan persetujuan → tampilkan snackbar
    if (userData?.approvalMessage != null &&
        userData!.approvalMessage!.isNotEmpty) {
      // Simpan pesan agar bisa digunakan di UI
      userService.tempApprovalMessage = userData.approvalMessage!;

      // Hapus pesan dari database agar tidak tampil lagi
      await userService.clearApprovalMessage(user.uid);
    }

    return userData;
  }
}
