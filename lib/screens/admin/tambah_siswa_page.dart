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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Siswa")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .where("role", isEqualTo: "siswa")
                  .where("linkedId", isEqualTo: "")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                final users = snapshot.data!.docs;

                return DropdownButtonFormField(
                  value: selectedUid,
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
            const SizedBox(height: 16),

            TextField(controller: nisC, decoration: const InputDecoration(labelText: "NIS")),
            TextField(controller: namaC, decoration: const InputDecoration(labelText: "Nama")),
            TextField(controller: kelasC, decoration: const InputDecoration(labelText: "Kelas")),
            TextField(controller: jurusanC, decoration: const InputDecoration(labelText: "Jurusan")),

            const SizedBox(height: 24),

            ElevatedButton(
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
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
