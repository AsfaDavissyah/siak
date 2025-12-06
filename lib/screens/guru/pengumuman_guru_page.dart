import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/pengumuman_service.dart';

class PengumumanGuruPage extends StatelessWidget {
  PengumumanGuruPage({super.key});

  final PengumumanService pengumumanService = PengumumanService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengumuman")),
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: pengumumanService.getPengumumanByRoleGabungan("guru"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi error"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada pengumuman"));
          }

          final list = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final data = list[index];

              return Card(
                child: ListTile(
                  title: Text(data["judul"]),
                  subtitle: Text(data["isi"]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
