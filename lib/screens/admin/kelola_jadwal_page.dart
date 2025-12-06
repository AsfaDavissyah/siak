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
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Jadwal Mengajar")),
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
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final j = data.data() as Map<String, dynamic>;

              return ListTile(
                title: Text("${j["mapel"]} - ${j["kelas"]}"),
                subtitle: Text("${j["hari"]} | ${j["jam"]} | ${j["guruNama"]}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditJadwalPage(
                              id: data.id,
                              data: j,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await jadwalService.deleteJadwal(data.id);
                      },
                    ),
                  ],
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
