import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/nilai_service.dart';

class NilaiAdminPage extends StatelessWidget {
  NilaiAdminPage({super.key});

  final NilaiService nilaiService = NilaiService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Nilai Siswa"),
        centerTitle: true,
        elevation: 0,
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
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header siswa + kelas
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: isDark
                                ? Colors.tealAccent.withOpacity(0.3)
                                : Colors.teal.withOpacity(0.15),
                            child: Icon(
                              Icons.person_outline,
                              size: 28,
                              color: isDark ? Colors.white : Colors.teal,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['siswaNama'],
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Kelas ${data['kelas']}",
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Detail Nilai
                      _infoRow("Mata Pelajaran", data['mapel'], Icons.book),
                      _infoRow("Guru Pengampu", data['guruNama'], Icons.badge),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _nilaiBox("Tugas", data['tugas'].toString(), isDark),
                          _nilaiBox("UTS", data['uts'].toString(), isDark),
                          _nilaiBox("UAS", data['uas'].toString(), isDark),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Nilai Akhir
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isDark
                              ? Colors.blueGrey.withOpacity(0.4)
                              : Colors.blue.shade50,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Nilai Akhir",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              data['nilaiAkhir'].toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.tealAccent : Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Predikat
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: _predikatColor(
                                data['predikat'], isDark),
                          ),
                          child: Text(
                            "Predikat ${data['predikat']}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.black : Colors.white,
                            ),
                          ),
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

  // ===========================================================
  // WIDGET KECIL — Info Row
  // ===========================================================
  Widget _infoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              "$label : $value",
              style: const TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }

  // ===========================================================
  // BOX NILAI TUGAS/UTS/UAS
  // ===========================================================
  Widget _nilaiBox(String label, String value, bool isDark) {
    return Container(
      width: 95,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // WARNA PREDIKAT
  // ===========================================================
  Color _predikatColor(String predikat, bool isDark) {
    switch (predikat) {
      case "A":
        return isDark ? Colors.greenAccent : Colors.green;
      case "B":
        return isDark ? Colors.blueAccent : Colors.blue;
      case "C":
        return isDark ? Colors.orangeAccent : Colors.orange;
      case "D":
        return isDark ? Colors.redAccent : Colors.red;
      default:
        return Colors.grey;
    }
  }
}
