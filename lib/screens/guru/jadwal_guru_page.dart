import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/jadwal_service.dart';

class JadwalGuruPage extends StatelessWidget {
  JadwalGuruPage({super.key});

  final JadwalService jadwalService = JadwalService();
  final String guruId = FirebaseAuth.instance.currentUser!.uid;
  
  get kelas => null;

  @override
  Widget build(BuildContext context) {
    print("EMAIL LOGIN: ${FirebaseAuth.instance.currentUser!.email}");
    print("UID LOGIN  : ${FirebaseAuth.instance.currentUser!.uid}");
    print("KELAS SISWA (DARI LOGIN): $kelas");
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Mengajar"), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('jadwal').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada jadwal mengajar"));
          }

          final jadwalList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jadwalList.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final data = jadwalList[index];
              return Card(
                child: ListTile(
                  title: Text(
                    data['mapel'],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "Hari: ${data['hari']}\n"
                    "Jam: ${data['jam']}\n"
                    "Kelas: ${data['kelas']}",
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
