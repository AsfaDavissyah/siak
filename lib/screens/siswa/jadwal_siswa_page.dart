import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/jadwal_service.dart';

class JadwalSiswaPage extends StatelessWidget {
  final String kelas;

  JadwalSiswaPage({super.key, required this.kelas});

  final JadwalService jadwalService = JadwalService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jadwal Pelajaran"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: jadwalService.getJadwalByKelas(kelas),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Belum ada jadwal untuk kelas ini"),
            );
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
                    data["mapel"],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "Guru: ${data["guruNama"]}\n"
                    "Hari: ${data["hari"]}\n"
                    "Jam: ${data["jam"]}",
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
