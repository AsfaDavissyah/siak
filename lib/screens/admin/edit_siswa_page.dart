import 'package:flutter/material.dart';
import '../../services/siswa_service.dart';

class EditSiswaPage extends StatefulWidget {
  final String id;
  final Map<String, dynamic> data;

  const EditSiswaPage({
    super.key,
    required this.id,
    required this.data,
  });

  @override
  State<EditSiswaPage> createState() => _EditSiswaPageState();
}

class _EditSiswaPageState extends State<EditSiswaPage> {
  late TextEditingController nisC;
  late TextEditingController namaC;
  late TextEditingController kelasC;
  late TextEditingController jurusanC;

  final siswaService = SiswaService();

  @override
  void initState() {
    super.initState();
    nisC = TextEditingController(text: widget.data["nis"]);
    namaC = TextEditingController(text: widget.data["nama"]);
    kelasC = TextEditingController(text: widget.data["kelas"]);
    jurusanC = TextEditingController(text: widget.data["jurusan"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Data Siswa")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: nisC, decoration: const InputDecoration(labelText: "NIS")),
            TextField(controller: namaC, decoration: const InputDecoration(labelText: "Nama")),
            TextField(controller: kelasC, decoration: const InputDecoration(labelText: "Kelas")),
            TextField(controller: jurusanC, decoration: const InputDecoration(labelText: "Jurusan")),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                await siswaService.updateSiswa(widget.id, {
                  "nis": nisC.text,
                  "nama": namaC.text,
                  "kelas": kelasC.text,
                  "jurusan": jurusanC.text,
                });

                Navigator.pop(context);
              },
              child: const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
