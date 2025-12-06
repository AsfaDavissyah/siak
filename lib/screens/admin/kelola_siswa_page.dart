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
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Data Siswa")),
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
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final siswa = data.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(siswa["nama"]),
                subtitle: Text("${siswa["kelas"]} - ${siswa["jurusan"]}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
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
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await siswaService.deleteSiswa(
                          data.id,
                          siswa["uid"],
                        );
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
            MaterialPageRoute(builder: (_) => TambahSiswaPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
