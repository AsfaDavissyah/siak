import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:printing/printing.dart';
import 'package:siak/utils/pdf_rapor.dart';
import '../../services/nilai_service.dart';

class RaporSiswaPage extends StatelessWidget {
  RaporSiswaPage({super.key});

  final NilaiService nilaiService = NilaiService();
  final String siswaId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rapor Siswa"),
        centerTitle: true,
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.picture_as_pdf),
        onPressed: () async {
          final snapshot = await nilaiService.getNilaiBySiswa(siswaId).first;

          if (snapshot.docs.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Belum ada nilai untuk dicetak")),
            );
            return;
          }

          final nilaiList = snapshot.docs
              .map((d) => d.data() as Map<String, dynamic>)
              .toList();

          final pdfData = await RaporPdfGenerator.generateRapor(
            namaSiswa: nilaiList[0]["siswaNama"] ?? "Tanpa Nama",
            kelas: nilaiList[0]["kelas"] ?? "-",
            nilaiList: nilaiList,
          );

          await Printing.layoutPdf(onLayout: (format) => pdfData);
        },
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: nilaiService.getNilaiBySiswa(siswaId),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada nilai rapor"));
          }

          final nilaiList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: nilaiList.length,
            itemBuilder: (context, index) {
              final n = nilaiList[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // MAPEL
                      Text(
                        n["mapel"] ?? "-",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // DETAIL NILAI
                      Row(
                        children: [
                          const Icon(Icons.person, size: 18),
                          const SizedBox(width: 8),
                          Text("Guru: ${n['guruNama'] ?? '-'}"),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(Icons.assignment, size: 18),
                          const SizedBox(width: 8),
                          Text("Tugas: ${n['tugas']}"),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(Icons.book, size: 18),
                          const SizedBox(width: 8),
                          Text("UTS: ${n['uts']}"),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(Icons.school, size: 18),
                          const SizedBox(width: 8),
                          Text("UAS: ${n['uas']}"),
                        ],
                      ),

                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(Icons.star, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "Nilai Akhir: ${n['nilaiAkhir'].toStringAsFixed(1)}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          const Icon(Icons.emoji_events, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            "Predikat: ${n['predikat']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
    );
  }
}
