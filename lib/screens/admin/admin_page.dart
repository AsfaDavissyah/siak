import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:siak/screens/admin/kelola_siswa_page.dart';
import 'package:siak/screens/admin/nilai_admin_page.dart';
import 'package:siak/screens/admin/pengumuman_admin_page.dart';

class AdminPage extends StatelessWidget {
  final String username;

  const AdminPage({super.key, required this.username});

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
        automaticallyImplyLeading: false,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TEKS SELAMAT DATANG
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
                  ],
                ),

                const Spacer(),

                // LOGOUT BUTTON + ICON
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
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Menu Admin",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),

            // MENU CARDS
            buildMenuCard(
              icon: Icons.people_alt_outlined,
              title: "Kelola Siswa",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => KelolaSiswaPage()),
                );
              },
            ),

            buildMenuCard(
              icon: Icons.person_outline,
              title: "Kelola Guru",
              onTap: () {
                Navigator.pushNamed(context, "/kelolaGuru");
              },
            ),

            buildMenuCard(
              icon: Icons.person_outline,
              title: "List ACC Guru Pending",
              onTap: () {
                Navigator.pushNamed(context, "/accGuru");
              },
            ),

            buildMenuCard(
              icon: Icons.person_outline,
              title: "List ACC Guru Siswa",
              onTap: () {
                Navigator.pushNamed(context, "/accSiswa");
              },
            ),

            buildMenuCard(
              icon: Icons.schedule_outlined,
              title: "Kelola Jadwal",
              onTap: () {
                Navigator.pushNamed(context, "/kelolaJadwal");
              },
            ),

            buildMenuCard(
              icon: Icons.campaign_outlined,
              title: "Kelola Pengumuman",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PengumumanAdminPage()),
                );
              },
            ),

            buildMenuCard(
              icon: Icons.bar_chart_outlined,
              title: "Lihat Nilai Siswa",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NilaiAdminPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
