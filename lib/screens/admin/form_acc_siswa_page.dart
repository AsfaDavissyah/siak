import 'package:flutter/material.dart';
import '../../services/siswa_service.dart';

class FormAccSiswaPage extends StatefulWidget {
  final String uid;
  final Map<String, dynamic> userData;

  const FormAccSiswaPage({
    super.key,
    required this.uid,
    required this.userData,
  });

  @override
  State<FormAccSiswaPage> createState() => _FormAccSiswaPageState();
}

class _FormAccSiswaPageState extends State<FormAccSiswaPage> {
  final siswaService = SiswaService();

  final TextEditingController nisC = TextEditingController();
  final TextEditingController namaC = TextEditingController();
  final TextEditingController kelasC = TextEditingController();
  final TextEditingController jurusanC = TextEditingController();

  @override
  void initState() {
    super.initState();
    namaC.text = widget.userData["name"]; // otomatis isi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ACC Siswa")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(controller: nisC, decoration: const InputDecoration(labelText: "NIS")),
            TextField(controller: namaC, decoration: const InputDecoration(labelText: "Nama")),
            TextField(controller: kelasC, decoration: const InputDecoration(labelText: "Kelas")),
            TextField(controller: jurusanC, decoration: const InputDecoration(labelText: "Jurusan")),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                await siswaService.accSiswa(
                  uid: widget.uid,
                  nis: nisC.text,
                  nama: namaC.text,
                  kelas: kelasC.text,
                  jurusan: jurusanC.text,
                );

                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("ACC Siswa"),
            ),
          ],
        ),
      ),
    );
  }
}
