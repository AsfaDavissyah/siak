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
    return Scaffold(
      appBar: AppBar(
        
        title: const Text("Nilai Saya"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: nilaiService.getNilaiBySiswa(siswaId),
        builder: (context, snapshot) {
          print("UID LOGIN SISWA: $siswaId");
      
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
            padding: const EdgeInsets.all(16),
            itemCount: nilaiList.length,
            itemBuilder: (context, index) {
              final data = nilaiList[index].data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(
                    data['mapel'] ?? "-",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text("Tugas : ${data['tugas']}"),
                      Text("UTS    : ${data['uts']}"),
                      Text("UAS    : ${data['uas']}"),
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
