import 'package:flutter/material.dart';
import 'package:siak/screens/admin/admin_page.dart';
import 'package:siak/screens/guru/guru_page.dart';
import 'package:siak/screens/siswa/siswa_page.dart';
import '../../services/auth_controller.dart';
import '../../models/user_model.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  final AuthController authController = AuthController();
  bool isLoading = false;

  void handleLogin() async {
  setState(() => isLoading = true);

  try {
    UserModel? user = await authController.loginAccount(
      email: emailC.text.trim(),
      password: passwordC.text.trim(),
    );

    if (user == null) {
      throw Exception("User tidak ditemukan.");
    }

    // ✅ Redirect sesuai role (TANPA userData)
    if (user.role == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => AdminPage(username: user.username)),
      );
    } 
    else if (user.role == "guru") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => GuruPage(username: user.username)),
      );
    } 
    else if (user.role == "siswa") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => SiswaPage(
            username: user.username,
            kelas: user.kelas, // ✅ AMBIL LANGSUNG DARI USER MODEL
          ),
        ),
      );
    } 
    else {
      throw Exception("Role tidak dikenali.");
    }

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login gagal: $e")),
    );
  }

  setState(() => isLoading = false);
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordC,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 20),

            // Tombol Login
            ElevatedButton(
              onPressed: isLoading ? null : handleLogin,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            ),

            const SizedBox(height: 20),

            // Pindah ke Register
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                );
              },
              child: const Text("Belum punya akun? Daftar"),
            ),
          ],
        ),
      ),
    );
  }
}
