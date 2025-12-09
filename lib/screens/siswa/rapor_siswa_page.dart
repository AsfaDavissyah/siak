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
    return Scaffold(
      appBar: AppBar(title: const Text("Rapor Siswa"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.picture_as_pdf),
        onPressed: () async {
          // Ambil semua nilai siswa
          final snapshot = await nilaiService.getNilaiBySiswa(siswaId).first;

          if (snapshot.docs.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Belum ada nilai untuk dicetak")),
            );
            return;
          }

          final nilaiList = snapshot.docs.map((d) {
            return d.data() as Map<String, dynamic>;
          }).toList();

          // Generate PDF
          final pdfData = await RaporPdfGenerator.generateRapor(
            namaSiswa: nilaiList[0]["siswaNama"] ?? "Tanpa Nama",
            kelas: nilaiList[0]["kelas"] ?? "-",
            nilaiList: nilaiList,
          );

          // Tampilkan / print PDF
          await Printing.layoutPdf(
            onLayout: (format) => pdfData,
          );
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
            padding: const EdgeInsets.all(16),
            itemCount: nilaiList.length,
            itemBuilder: (context, index) {
              final data = nilaiList[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                child: ListTile(
                  title: Text(
                    data["mapel"] ?? "-",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Guru : ${data['guruNama'] ?? '-'}"),
                        Text("Tugas : ${data['tugas']}"),
                        Text("UTS : ${data['uts']}"),
                        Text("UAS : ${data['uas']}"),
                        Text(
                          "Nilai Akhir : ${data['nilaiAkhir'].toStringAsFixed(1)}",
                        ),
                        Text(
                          "Predikat : ${data['predikat']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
