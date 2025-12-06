import 'auth_service.dart';
import 'user_service.dart';
import '../models/user_model.dart';

class AuthController {
  final AuthService authService = AuthService();
  final UserService userService = UserService();

  // ✅ EMAIL ADMIN TETAP (KUNCI UTAMA)
  static const String adminEmail = "admin@sisakademik.com";

  // ==========================
  // REGISTER USER
  // ==========================
  Future<void> registerAccount({
    required String email,
    required String password,
    required String name,
    required String username,
    required String role,
    required String linkedId,
  }) async {

    // 1️⃣ Validasi input dasar
    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      throw Exception("Email, password, dan username wajib diisi.");
    }

    // 2️⃣ BLOKIR ADMIN DARI REGISTER UMUM
    if (email.toLowerCase() == adminEmail) {
      throw Exception("Akun admin tidak boleh didaftarkan dari halaman register.");
    }

    if (role.toLowerCase() == "admin") {
      throw Exception("Role admin hanya boleh dibuat satu kali oleh sistem.");
    }

    // 3️⃣ Validasi role yang diizinkan
    const allowedRoles = ["guru", "siswa"];
    if (!allowedRoles.contains(role.toLowerCase())) {
      throw Exception("Role tidak valid. Hanya guru atau siswa yang diperbolehkan.");
    }

    // 4️⃣ REGISTER ke Firebase Auth
    final user = await authService.registerUser(
      email: email,
      password: password,
    );

    if (user == null) {
      throw Exception("Gagal membuat akun.");
    }

    // 5️⃣ SIMPAN DATA KE FIRESTORE
    final userModel = UserModel(
      uid: user.uid,
      name: name,
      username: username,
      role: role.toLowerCase(), // hanya guru / siswa
      linkedId: linkedId,
      kelas: ''
    );

    await userService.saveUserData(userModel);
  }

  // ==========================
  // LOGIN USER
  // ==========================
  Future<UserModel?> loginAccount({
    required String email,
    required String password,
  }) async {

    // 1️⃣ Login ke Auth
    final user = await authService.loginUser(
      email: email,
      password: password,
    );

    if (user == null) {
      throw Exception("Login gagal.");
    }

    // 2️⃣ Ambil data user dari Firestore
    final userData = await userService.getUserByUid(user.uid);

    if (userData == null) {
      throw Exception("Data user tidak ditemukan di Firestore.");
    }

    return userData;
  }
}
