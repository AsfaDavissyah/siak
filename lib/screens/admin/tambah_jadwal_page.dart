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

  Widget buildInput({
    required String label,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.withOpacity(0.08),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue, width: 1.3),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Jadwal"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "Lengkapi data jadwal berikut dengan benar.",
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),

            const SizedBox(height: 20),

            // Dropdown Guru
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("role", isEqualTo: "guru")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final gurus = snapshot.data!.docs;

                return DropdownButtonFormField(
                  hint: const Text("Pilih Guru"),
                  value: selectedGuruId,
                  items: gurus.map((doc) {
                    final g = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text(g["name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final selectedDoc = gurus.firstWhere((d) => d.id == value);
                    final g = selectedDoc.data() as Map<String, dynamic>;

                    setState(() {
                      selectedGuruId = value;
                      selectedGuruNama = g["name"];
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            buildInput(label: "Mata Pelajaran", controller: mapelC),
            const SizedBox(height: 16),

            buildInput(label: "Kelas", controller: kelasC),
            const SizedBox(height: 16),

            buildInput(label: "Hari", controller: hariC),
            const SizedBox(height: 16),

            buildInput(label: "Jam", controller: jamC),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Simpan Jadwal",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
