import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:siak/screens/admin/kelola_siswa_page.dart';
import 'package:siak/screens/admin/nilai_admin_page.dart';

class AdminPage extends StatelessWidget {
  final String username;

  const AdminPage({super.key, required this.username});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Selamat datang, $username",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "Silakan pilih menu di bawah ini:",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 30),

            // Kelola Siswa
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => KelolaSiswaPage()),
                );
              },
              child: const Text("Kelola Siswa"),
            ),
            const SizedBox(height: 12),

            // Kelola Guru
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/kelolaGuru");
              },
              child: const Text("Kelola Data Guru"),
            ),
            const SizedBox(height: 12),

            // Kelola Jadwal
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/kelolaJadwal");
              },
              child: const Text("Kelola Jadwal"),
            ),
            const SizedBox(height: 12),

            // Pengumuman
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/pengumumanAdmin");
              },
              child: const Text("Kelola Pengumuman"),
            ),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NilaiAdminPage()),
                );
              },
              child: const Text("Lihat Nilai Siswa"),
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () => logout(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
