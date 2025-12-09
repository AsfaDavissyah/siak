import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/pengumuman_service.dart';

class PengumumanGuruPage extends StatelessWidget {
  PengumumanGuruPage({super.key});

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
        stream: pengumumanService.getPengumumanByRoleGabungan("guru"),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi error saat mengambil data"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada pengumuman"));
          }

          final pengumumanList = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: pengumumanList.length,
            itemBuilder: (context, index) {
              final p = pengumumanList[index].data() as Map<String, dynamic>;

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

                      // 🔹 Judul pengumuman
                      Text(
                        p["judul"] ?? "-",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // 🔹 Isi pengumuman
                      Text(
                        p["isi"] ?? "-",
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 🔹 Baris info bawah
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.info_outline, size: 16),
                              SizedBox(width: 6),
                              Text(
                                "Untuk Guru",
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 14),
                              const SizedBox(width: 6),

                              Text(
                                (p["createdAt"] ?? "").toString().split(" ").first,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
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
