import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/nilai_service.dart';

class NilaiAdminPage extends StatelessWidget {
  NilaiAdminPage({super.key});

  final NilaiService nilaiService = NilaiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Nilai Siswa"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: nilaiService.getAllNilai(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Belum ada data nilai"),
            );
          }

          final nilaiList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: nilaiList.length,
            itemBuilder: (context, index) {
              final data = nilaiList[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    "${data['siswaNama']} - ${data['kelas']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text("Mapel : ${data['mapel']}"),
                      Text("Guru  : ${data['guruNama']}"),
                      const SizedBox(height: 6),
                      Text("Tugas : ${data['tugas']}"),
                      Text("UTS   : ${data['uts']}"),
                      Text("UAS   : ${data['uas']}"),
                      const SizedBox(height: 6),
                      Text(
                        "Nilai Akhir : ${data['nilaiAkhir'].toStringAsFixed(1)}",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Predikat : ${data['predikat']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
