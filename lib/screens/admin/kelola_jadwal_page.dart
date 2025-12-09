import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/jadwal_service.dart';
import 'tambah_jadwal_page.dart';
import 'edit_jadwal_page.dart';

class KelolaJadwalPage extends StatelessWidget {
  KelolaJadwalPage({super.key});

  final JadwalService jadwalService = JadwalService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Jadwal Mengajar"),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: jadwalService.getAllJadwal(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Belum ada jadwal"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final j = data.data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ICON MAPEL
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: isDark
                            ? Colors.teal.withOpacity(0.3)
                            : Colors.teal.withOpacity(0.15),
                        child: Icon(
                          Icons.book_rounded,
                          size: 28,
                          color: isDark ? Colors.white : Colors.teal,
                        ),
                      ),

                      const SizedBox(width: 14),

                      // INFORMASI JADWAL
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Mapel + Kelas
                            Text(
                              "${j["mapel"]} - ${j["kelas"]}",
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            // Hari & Jam
                            Row(
                              children: [
                                Icon(Icons.calendar_today_rounded,
                                    size: 16,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54),
                                const SizedBox(width: 4),
                                Text(
                                  j["hari"],
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(Icons.schedule_rounded,
                                    size: 16,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54),
                                const SizedBox(width: 4),
                                Text(
                                  j["jam"],
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            // Nama Guru
                            Row(
                              children: [
                                Icon(Icons.person_outline_rounded,
                                    size: 16,
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54),
                                const SizedBox(width: 4),
                                Text(
                                  j["guruNama"],
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

                      // ACTION BUTTONS
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditJadwalPage(id: data.id, data: j),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              await jadwalService.deleteJadwal(data.id);
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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahJadwalPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
