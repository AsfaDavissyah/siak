import 'package:flutter/material.dart';
import '../../services/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController usernameC = TextEditingController();

  // ✅ Role default = siswa (ADMIN SUDAH DIKUNCI)
  String selectedRole = "siswa";

  final AuthController authController = AuthController();
  bool isLoading = false;

  void handleRegister() async {
    setState(() => isLoading = true);

    try {
      await authController.registerAccount(
        email: emailC.text.trim(),
        password: passwordC.text.trim(),
        name: nameC.text.trim(),
        username: usernameC.text.trim(),
        role: selectedRole,
        linkedId: "",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi berhasil. Silakan login."),
        ),
      );

      // ✅ PASTI KEMBALI KE LOGIN
      Navigator.pushReplacementNamed(context, "/");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registrasi gagal: $e")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameC,
              decoration: const InputDecoration(labelText: "Nama Lengkap"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: usernameC,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 12),

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

            // ✅ ADMIN SUDAH DIHILANGKAN
            DropdownButtonFormField(
              value: selectedRole,
              items: const [
                DropdownMenuItem(value: "guru", child: Text("Guru")),
                DropdownMenuItem(value: "siswa", child: Text("Siswa")),
              ],
              onChanged: (value) {
                setState(() => selectedRole = value!);
              },
              decoration: const InputDecoration(labelText: "Role"),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: isLoading ? null : handleRegister,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
