import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/siswa_service.dart';

class TambahSiswaPage extends StatefulWidget {
  const TambahSiswaPage({super.key});

  @override
  State<TambahSiswaPage> createState() => _TambahSiswaPageState();
}

class _TambahSiswaPageState extends State<TambahSiswaPage> {
  final TextEditingController nisC = TextEditingController();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController kelasC = TextEditingController();
  final TextEditingController jurusanC = TextEditingController();

  String? selectedUid;

  final siswaService = SiswaService();

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
        title: const Text("Tambah Siswa"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "Hubungkan akun siswa dengan data siswa sekolah.",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // 🔽 Dropdown pilih akun siswa
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("role", isEqualTo: "siswa")
                  .where("linkedId", isEqualTo: "")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs;

                return DropdownButtonFormField(
                  value: selectedUid,
                  decoration: InputDecoration(
                    labelText: "Akun Siswa",
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  hint: const Text("Pilih Akun Siswa"),
                  items: users.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text(data["username"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedUid = value);
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            buildInput(label: "NIS", controller: nisC),
            const SizedBox(height: 16),

            buildInput(label: "Nama Siswa", controller: namaC),
            const SizedBox(height: 16),

            buildInput(label: "Kelas", controller: kelasC),
            const SizedBox(height: 16),

            buildInput(label: "Jurusan", controller: jurusanC),
            const SizedBox(height: 28),

            // 🔽 Tombol Simpan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedUid == null) return;

                  await siswaService.tambahSiswa(
                    uid: selectedUid!,
                    nis: nisC.text,
                    nama: namaC.text,
                    kelas: kelasC.text,
                    jurusan: jurusanC.text,
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
                  "Simpan Data Siswa",
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
