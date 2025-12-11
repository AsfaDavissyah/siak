import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/siswa_service.dart';
import 'tambah_siswa_page.dart';
import 'edit_siswa_page.dart';

class KelolaSiswaPage extends StatelessWidget {
  KelolaSiswaPage({super.key});

  final SiswaService siswaService = SiswaService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Data Siswa"),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: siswaService.getAllSiswa(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Belum ada data siswa"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final siswa = data.data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Avatar Siswa
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: isDark
                            ? Colors.blueAccent.withOpacity(0.3)
                            : Colors.blueAccent.withOpacity(0.15),
                        child: Icon(
                          Icons.person_outline,
                          size: 28,
                          color: isDark ? Colors.white : Colors.blueAccent,
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Informasi siswa
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama siswa
                            Text(
                              siswa["nama"],
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Kelas & Jurusan
                            Row(
                              children: [
                                Icon(Icons.school_rounded,
                                    size: 16,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54),
                                const SizedBox(width: 4),
                                Text(
                                  "${siswa["kelas"]} - ${siswa["jurusan"]}",
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Actions
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditSiswaPage(
                                    id: data.id,
                                    data: siswa,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              await siswaService.deleteSiswa(
                                data.id,
                                siswa["uid"],
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => TambahSiswaPage()),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
