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

  Widget buildMenuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        // title: const Text("Dashboard Siswa"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text kiri
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat datang,",
                      style: TextStyle(
                        fontSize: 18,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      "Kelas: $kelas",
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 22),
                  ],
                ),

                const Spacer(),

                // Logout button
                TextButton.icon(
                  onPressed: () => logout(context),
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Text(
              "Menu Siswa",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 16),

            // MENU LIST
            buildMenuCard(
              icon: Icons.schedule_outlined,
              title: "Lihat Jadwal",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JadwalSiswaPage(kelas: kelas),
                  ),
                );
              },
            ),

            buildMenuCard(
              icon: Icons.bar_chart_outlined,
              title: "Lihat Nilai",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NilaiSiswaPage()),
                );
              },
            ),

            buildMenuCard(
              icon: Icons.campaign_outlined,
              title: "Pengumuman",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PengumumanSiswaPage()),
                );
              },
            ),

            buildMenuCard(
              icon: Icons.picture_as_pdf_outlined,
              title: "Lihat Rapor",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RaporSiswaPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
