import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/guru_service.dart';
import 'tambah_guru_page.dart';
import 'edit_guru_page.dart';

class KelolaGuruPage extends StatelessWidget {
  KelolaGuruPage({super.key});

  final GuruService guruService = GuruService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kelola Data Guru")),
      body: StreamBuilder<QuerySnapshot>(
        stream: guruService.getAllGuru(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Belum ada data guru"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final guru = data.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(guru["nama"]),
                subtitle: Text("${guru["nip"]} - ${guru["mapel"]}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditGuruPage(
                              id: data.id,
                              data: guru,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await guruService.deleteGuru(
                          data.id,
                          guru["uid"],
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
            MaterialPageRoute(builder: (_) => TambahGuruPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
