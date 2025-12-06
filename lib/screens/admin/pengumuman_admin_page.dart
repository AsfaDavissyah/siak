import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/pengumuman_service.dart';
import 'tambah_pengumuman_page.dart';

class PengumumanAdminPage extends StatelessWidget {
  PengumumanAdminPage({super.key});

  final PengumumanService pengumumanService = PengumumanService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Pengumuman"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahPengumumanPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: pengumumanService.getAllPengumuman(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final list = snapshot.data!.docs;

          if (list.isEmpty) {
            return const Center(child: Text("Belum ada pengumuman"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final data = list[index];
              return Card(
                child: ListTile(
                  title: Text(data["judul"]),
                  subtitle: Text(data["isi"]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      pengumumanService.hapusPengumuman(data.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
