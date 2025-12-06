import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'input_nilai_guru_page.dart';
import 'jadwal_guru_page.dart';

class GuruPage extends StatelessWidget {
  final String username;

  const GuruPage({super.key, required this.username});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Guru"),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
            const SizedBox(height: 20),

            // ✅ LIHAT JADWAL
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => JadwalGuruPage()),
                );
              },
              child: const Text("Jadwal Mengajar"),
            ),

            const SizedBox(height: 12),

            // ✅ INPUT NILAI
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InputNilaiGuruPage()),
                );
              },
              child: const Text("Input Nilai"),
            ),

            const SizedBox(height: 12),

            // ✅ PENGUMUMAN (NANTI KITA SAMBUNGKAN KE ADMIN)
            ElevatedButton(
              onPressed: () {},
              child: const Text("Pengumuman"),
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
