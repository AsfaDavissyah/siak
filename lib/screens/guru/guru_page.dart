import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:siak/screens/guru/pengumuman_guru_page.dart';
import 'input_nilai_guru_page.dart';
import 'jadwal_guru_page.dart';

class GuruPage extends StatelessWidget {
  final String username;
  

  const GuruPage({super.key, required this.username});

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

            // ======================================================
            // HEADER & LOGOUT
            // ======================================================
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

            const SizedBox(height: 30),

            const Text(
              "Menu Guru",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            // ======================
            // MENU LIST
            // ======================
            buildMenuCard(
              icon: Icons.schedule_outlined,
              title: "Jadwal Mengajar",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => JadwalGuruPage()),
                );
              },
            ),

            buildMenuCard(
              icon: Icons.edit_note_outlined,
              title: "Input Nilai",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InputNilaiGuruPage()),
                );
              },
            ),

            buildMenuCard(
              icon: Icons.campaign_outlined,
              title: "Pengumuman",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PengumumanGuruPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
