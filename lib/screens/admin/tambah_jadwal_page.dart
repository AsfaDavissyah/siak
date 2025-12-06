import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/jadwal_service.dart';

class TambahJadwalPage extends StatefulWidget {
  const TambahJadwalPage({super.key});

  @override
  State<TambahJadwalPage> createState() => _TambahJadwalPageState();
}

class _TambahJadwalPageState extends State<TambahJadwalPage> {
  final TextEditingController mapelC = TextEditingController();
  final TextEditingController kelasC = TextEditingController();
  final TextEditingController hariC = TextEditingController();
  final TextEditingController jamC = TextEditingController();

  String? selectedGuruId;
  String? selectedGuruNama;

  final jadwalService = JadwalService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Jadwal")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("role", isEqualTo: "guru")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final gurus = snapshot.data!.docs;

                return DropdownButtonFormField(
                  hint: const Text("Pilih Guru"),
                  value: selectedGuruId,
                  items: gurus.map((doc) {
                    final g = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: doc.id, // ✅ INI UID ASLI FIREBASE
                      child: Text(g["name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final selectedDoc = gurus.firstWhere(
                      (doc) => doc.id == value, 
                    );

                    final g = selectedDoc.data() as Map<String, dynamic>;

                    setState(() {
                      selectedGuruId = value as String;
                      selectedGuruNama = g["name"];
                    });
                  },
                );
              },
            ),

            TextField(
              controller: mapelC,
              decoration: const InputDecoration(labelText: "Mapel"),
            ),
            TextField(
              controller: kelasC,
              decoration: const InputDecoration(labelText: "Kelas"),
            ),
            TextField(
              controller: hariC,
              decoration: const InputDecoration(labelText: "Hari"),
            ),
            TextField(
              controller: jamC,
              decoration: const InputDecoration(labelText: "Jam"),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                if (selectedGuruId == null) return;

                await jadwalService.tambahJadwal(
                  guruId: selectedGuruId!,
                  guruNama: selectedGuruNama!,
                  mapel: mapelC.text,
                  kelas: kelasC.text,
                  hari: hariC.text,
                  jam: jamC.text,
                );

                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
