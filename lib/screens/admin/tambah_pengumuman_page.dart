import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/pengumuman_service.dart';

class TambahPengumumanPage extends StatefulWidget {
  const TambahPengumumanPage({super.key});

  @override
  State<TambahPengumumanPage> createState() => _TambahPengumumanPageState();
}

class _TambahPengumumanPageState extends State<TambahPengumumanPage> {
  final judulC = TextEditingController();
  final isiC = TextEditingController();
  String tujuan = "semua";

  final PengumumanService pengumumanService = PengumumanService();
  final String adminId = FirebaseAuth.instance.currentUser!.uid;

  Widget buildInput({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
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
        title: const Text("Tambah Pengumuman"),
        centerTitle: true,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "Buat pengumuman baru untuk disampaikan kepada guru atau siswa.",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 20),

            buildInput(label: "Judul Pengumuman", controller: judulC),
            const SizedBox(height: 16),

            buildInput(
              label: "Isi Pengumuman",
              controller: isiC,
              maxLines: 4,
            ),
            const SizedBox(height: 16),

            DropdownButtonFormField(
              value: tujuan,
              decoration: InputDecoration(
                labelText: "Tujuan",
                filled: true,
                fillColor: Colors.grey.withOpacity(0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                    value: "semua", child: Text("Semua Pengguna")),
                DropdownMenuItem(
                    value: "guru", child: Text("Guru Saja")),
                DropdownMenuItem(
                    value: "siswa", child: Text("Siswa Saja")),
              ],
              onChanged: (value) {
                setState(() => tujuan = value!);
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await pengumumanService.tambahPengumuman(
                    judul: judulC.text,
                    isi: isiC.text,
                    tujuan: tujuan,
                    adminId: adminId,
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
                  "Publikasikan Pengumuman",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
