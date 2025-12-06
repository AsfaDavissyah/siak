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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Pengumuman")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: judulC,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            TextField(
              controller: isiC,
              decoration: const InputDecoration(labelText: "Isi"),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField(
              value: tujuan,
              items: const [
                DropdownMenuItem(value: "semua", child: Text("Semua")),
                DropdownMenuItem(value: "guru", child: Text("Guru")),
                DropdownMenuItem(value: "siswa", child: Text("Siswa")),
              ],
              onChanged: (value) {
                setState(() => tujuan = value!);
              },
              decoration: const InputDecoration(labelText: "Tujuan"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await pengumumanService.tambahPengumuman(
                  judul: judulC.text,
                  isi: isiC.text,
                  tujuan: tujuan,
                  adminId: adminId,
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
