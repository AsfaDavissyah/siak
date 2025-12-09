import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/nilai_service.dart';

class NilaiSiswaPage extends StatelessWidget {
  NilaiSiswaPage({super.key});

  final NilaiService nilaiService = NilaiService();
  final String siswaId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Nilai Saya"),
        centerTitle: true,
        elevation: 0,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: nilaiService.getNilaiBySiswa(siswaId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Belum ada nilai"),
            );
          }

          final nilaiList = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: nilaiList.length,
            itemBuilder: (context, index) {
              final n = nilaiList[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 16),

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

                      // NILAI TUGAS
                      Row(
                        children: [
                          Icon(Icons.assignment_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text("Tugas: ${n['tugas']}"),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // NILAI UTS
                  
                      Row(
                        children: [
                          Icon(Icons.quiz_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text("UTS: ${n['uts']}"),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // NILAI UAS
                      Row(
                        children: [
                          Icon(Icons.menu_book_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text("UAS: ${n['uas']}"),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Divider(),

                      // NILAI AKHIR
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.grade_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "Nilai Akhir: ${n['nilaiAkhir'].toStringAsFixed(1)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // PREDIKAT
                      Row(
                        children: [
                          const Icon(Icons.flag_outlined, size: 20),
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
