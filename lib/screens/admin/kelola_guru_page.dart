import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/guru_service.dart';
import 'tambah_guru_page.dart';
import 'edit_guru_page.dart';

class KelolaGuruPage extends StatelessWidget {
  KelolaGuruPage({super.key});

  final GuruService guruService = GuruService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Data Guru"),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: guruService.getAllGuru(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Belum ada data guru"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];
              final guru = data.data() as Map<String, dynamic>;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ICON
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: isDark
                            ? Colors.blueGrey
                            : Colors.blue.withOpacity(0.15),
                        child: Icon(
                          Icons.person_rounded,
                          size: 30,
                          color: isDark ? Colors.white : Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 14),

                      // TEXT INFORMASI GURU
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guru["nama"],
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "NIP       : ${guru["nip"]}",
                              style: TextStyle(
                                color:
                                    isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            Text(
                              "Mapel   : ${guru["mapel"]}",
                              style: TextStyle(
                                color:
                                    isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ACTION BUTTONS
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditGuruPage(
                                    id: data.id,
                                    data: guru,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () async {
                              await guruService.deleteGuru(
                                data.id,
                                guru["uid"],
                              );
                            },
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

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => TambahGuruPage()),
      //     );
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
