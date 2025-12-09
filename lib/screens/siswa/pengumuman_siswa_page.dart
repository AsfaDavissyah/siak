import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/pengumuman_service.dart';

class PengumumanSiswaPage extends StatelessWidget {
  PengumumanSiswaPage({super.key});

  final PengumumanService pengumumanService = PengumumanService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengumuman"),
        centerTitle: true,
        elevation: 0,
      ),

      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: pengumumanService.getPengumumanByRoleGabungan("siswa"),
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
            padding: const EdgeInsets.all(20),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final data = list[index].data() as Map<String, dynamic>;

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
                      // JUDUL
                      Text(
                        data["judul"] ?? "-",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ISI PENGUMUMAN
                      Text(
                        data["isi"] ?? "-",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 14),
                      const Divider(),

                      const SizedBox(height: 8),

                      // TANGGAL (opsional)
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 18),
                          const SizedBox(width: 6),
                          Text(
                            data["tanggal"] ?? "Tanpa tanggal",
                            style: TextStyle(
                              color:
                                  isDark ? Colors.white70 : Colors.black54,
                              fontSize: 13,
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
