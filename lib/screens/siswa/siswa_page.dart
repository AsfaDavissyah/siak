import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:siak/screens/siswa/nilai_siswa_page.dart';
import 'package:siak/screens/siswa/pengumuman_siswa_page.dart';
import 'package:siak/screens/siswa/rapor_siswa_page.dart';
import 'jadwal_siswa_page.dart';

class SiswaPage extends StatelessWidget {
  final String username;
  final String kelas;

  const SiswaPage({super.key, required this.username, required this.kelas});

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, "/");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Siswa")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Selamat datang, $username",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text("Kelas: $kelas"),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JadwalSiswaPage(kelas: kelas),
                  ),
                );
              },
              child: const Text("Lihat Jadwal"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NilaiSiswaPage()),
                );
              },
              child: const Text("Lihat Nilai"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PengumumanSiswaPage()),
                );
              },
              child: const Text("Pengumuman"),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RaporSiswaPage()),
                );
              },
              child: const Text("Lihat Rapor"),
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
